# Checklist de Sécurité Mobile — Kauri Financial App

> **Revue de sécurité post-audit (K-01 à K-35).**
> Statut vérifié ligne par ligne dans le code (client Flutter + API `djangui-api`)
> le 2026-08-24 — pas une auto-déclaration. Deux points restent explicitement
> ouverts (voir en bas). Revalider cette checklist avant chaque release.

---

## 🔐 Stockage, Secrets & Données Locales

| # | Item / Audit Ref | Statut | Détail de Remédiation |
|---|-------------------|--------|------------------------|
| 1 | Tokens d'accès/refresh stockés dans `flutter_secure_storage` | ✅ Validé | Chiffrement matériel / KeyStore / Keychain |
| 2 | PIN utilisateur stocké via `flutter_secure_storage` avec chiffrement AES | ✅ Validé | Stockage chiffré dans le secure storage |
| 3 | Aucune clé API / secret dans le code source ou les assets | ✅ Validé | Variables injectées à la compilation via Dart Defines / env |
| 4 | `.env` et clés de signature exclus du git (**K-22**) | ✅ Validé | `*.keystore`, `*.jks`, `key.properties`, `*.p12` dans `.gitignore` |
| 5 | Base de données SQLite locale chiffrée | ✅ Validé | `sqlite3mc` (build chiffrant, PRAGMA key) + clé aléatoire 256 bits en secure storage — `sqlcipher_flutter_libs` est EOL et n'est plus utilisé |
| 6 | Redaction des credentials en mémoire et logs (**K-06**) | ✅ Validé | Mot de passe retiré du `debugPrint` d'inscription ; jamais persisté |
| 7 | Auto-clear du presse-papier (**K-05, K-27**) | ✅ Validé | Effacement automatique après 45s pour email/mot de passe/PIN du coffre-fort Reseller |

---

## 🌐 Sécurité Réseau & Intercepteurs

| # | Item / Audit Ref | Statut | Détail de Remédiation |
|---|-------------------|--------|------------------------|
| 8 | Interdiction du trafic HTTP en clair | ✅ Validé | `usesCleartextTraffic="false"` + `network_security_config.xml` |
| 8b | Certificate/SPKI Pinning sur l'API Kauri (**K-08**) | ⚠️ Partiel | Pin-set Android réel (intermédiaire + racine Let's Encrypt + feuille courant) sur `api.kauri-app.com` uniquement — **pas de pinning côté iOS**, et aucun pinning cross-plateforme au niveau Dart (limite native de `dart:io HttpClient`, qui n'expose que le certificat feuille). Nécessite soit du code natif Swift, soit une librairie tierce (ex. `http_certificate_pinning`) — décision à valider avec l'équipe avant ajout d'une dépendance sécurité-critique. Domaines de paiement tiers (Stripe/NotchPay) volontairement non épinglés — anti-pattern documenté sur une infra qu'on ne contrôle pas. |
| 9 | Timeout réseau global strict (**K-09**) | ✅ Validé | `TracingHttpClient` : 20s max par requête, tous endpoints |
| 10 | Idempotency-Key sur les endpoints financiers (**K-10**) | ✅ Validé | Intercepteur Dart génère une clé par requête sortante sur withdraw/contribute/redeem/deposit/checkout ; déduplication déjà implémentée côté API (Redis `SET NX`, `src/middleware/idempotency.ts`) |
| 11 | Rejeu de la file hors-ligne sans double-traitement (**K-17**) | ✅ Validé | Clé d'idempotence stable générée à la mise en attente, réutilisée à chaque tentative de rejeu (contribution d'objectif) ; middleware API mis à jour pour lire cette clé depuis le corps de requête |
| 12 | Filtrage des headers sensibles dans les logs réseau (**K-12**) | ✅ Validé | En-tête `Authorization` masqué avant tout `debugPrint` |
| 13 | Masquage des corps de requête sensibles (**K-11**) | ✅ Validé | `/fintech/`, `/payments/`, `/transactions/`, `/reseller/`, `/vault` masqués (local ET distant) |

---

## 📱 Sécurité Application, RASP & Code Hardening

| # | Item / Audit Ref | Statut | Détail de Remédiation |
|---|-------------------|--------|------------------------|
| 14 | Détection Root/Jailbreak & RASP active (**K-21**) | ✅ Validé | FreeRASP : menaces critiques (root, hooks, intégrité, émulateur) tuent l'app en release ; menaces ambiguës (matériel sécurisé absent, binding, store non-officiel) journalisées sans bloquer, pour éviter de verrouiller des utilisateurs légitimes |
| 15 | Obfuscation Dart & séparation des symboles (**K-19**) | ✅ Validé | `--obfuscate --split-debug-info=build/symbols` documenté dans `DEPLOYMENT.md` (aucun pipeline CI ne buildait de release à corriger) |
| 16 | R8 / ProGuard optimisé (**K-20**) | ✅ Validé | `-keep` réduit à `MainActivity` uniquement — le reste du code applicatif est obfusqué |
| 17 | Masquage écran Android (FLAG_SECURE) (**K-23, K-25**) | ✅ Validé | `SecureScreenMixin` appliqué : Wallet, TransactionDetail, Security, OTP, KYC, Reseller Hub, Dashboard, Budgets (liste + création), Goal Detail, Profile. PIN du coffre-fort désormais masqué à la saisie. |
| 18 | Masquage écran iOS App Switcher (**K-24**) | ✅ Validé | Flou (`UIVisualEffectView`) posé sur toute la fenêtre dans `AppDelegate.swift` lors du passage en arrière-plan — comportement global à l'app, pas seulement aux écrans utilisant le mixin |
| 19 | Désactivation suggestions/autocorrect clavier (**K-26**) | ✅ Validé | `AppTextField` désactive `enableSuggestions`/`autocorrect` par défaut dès que `isPassword: true` |

---

## 🔑 Authentification & Sessions

| # | Item / Audit Ref | Statut | Détail de Remédiation |
|---|-------------------|--------|------------------------|
| 20 | Révocation serveur lors de la déconnexion (**K-01**) | ✅ Validé | Client : `POST /auth/logout` (best-effort, timeout 5s) avant nettoyage local. Serveur : suppression de la session + **blacklist Redis du access token** pour sa durée de validité restante — vérifié dans `authService.ts` |
| 21 | Verrouillage automatique après inactivité (**K-02**) | ✅ Validé | Au-delà de 2 min en arrière-plan, déconnexion réelle (`AuthLogoutRequested`) forçant une ré-authentification complète — la version précédente ne faisait qu'une revalidation silencieuse du token sans jamais rien verrouiller |
| 22 | Biométrie stricte sans contournement (**K-03**) | ✅ Validé | `AuthenticationOptions(biometricOnly: true)` — le code/schéma appareil ne satisfait plus le prompt |
| 23 | Réinitialisation de tous les BLoCs au logout (**K-04**) | ✅ Validé | `Transactions`, `Goals`, `Budgets`, `Challenges`, `Tontine`, `Subscription`, `Dashboard`, `Fintech` — tous vidés à la déconnexion |
| 24 | Mutex de rafraîchissement de token sans régression | ✅ Validé | Correction d'une régression introduite pendant cette remédiation : la branche d'échec appelait `.complete()` au lieu de `.completeError()`, faisant retenter les requêtes concurrentes avec un token déjà invalide |

---

## 💳 Logique Financière, Précision & Idempotence

| # | Item / Audit Ref | Statut | Détail de Remédiation |
|---|-------------------|--------|------------------------|
| 25 | **Précision des montants (K-13)** | 🔴 **Ouvert** | Tous les montants restent des `double` (IEEE-754), côté client (Drift `RealColumn`, modèles API) ET côté serveur (Mongoose `Number`). Non corrigé dans cette passe : une migration entiers/`Decimal128` touche le schéma DB des deux dépôts, tous les modèles, tous les calculs d'affichage, ET les données déjà en production — trop risqué pour un correctif unilatéral sans plan de migration dédié (double-écriture, backfill, coordination client/serveur). **Nécessite une décision produit/ingénierie séparée avant d'être traité.** |
| 26 | Validation des montants positifs (**K-14 partiel**) | ✅ Validé | `FintechBloc.RequestWithdrawal` rejette les montants `<= 0`, NaN ou infinis |
| 27 | Prévention des doubles soumissions financières (**K-14, K-15**) | ✅ Validé | `droppable()` sur tous les événements BLoC financiers (transactions, budgets, objectifs, tontines, retraits, abonnements) |
| 28 | Rollback optimiste local sur échec serveur (**K-16**) | ✅ Validé | Suppression de l'écriture locale optimiste si le serveur rejette la transaction en ligne |
| 29 | Validation du statut de paiement réel (**K-18**) | ✅ Validé | Écran de succès affiche un échec explicite (pas de faux succès) si aucune référence de transaction n'est fournie |
| 30 | Gestion d'erreur sans fallback fallacieux (**K-34**) | ✅ Validé | Retiré sur les 5 méthodes de lecture tontine (liste, détails, membres, messages, contributions) — un échec serveur ne renvoie plus silencieusement le cache comme un succès |
| 31 | Lien de partage d'objectif validé défensivement (**K-28**) | ⚠️ Partiel | Bornes ajoutées (taille du jeton, montants finis/positifs/plausibles, échéance raisonnable, nom non-vide) avant affichage. **Le lien reste non signé cryptographiquement** — un serveur doit émettre/valider une référence signée pour une garantie d'authenticité complète ; l'import exige toujours une confirmation explicite de l'utilisateur, ce qui limite l'impact réel. |

---

## 📊 Télémétrie, Logs & Confidentialité

| # | Item / Audit Ref | Statut | Détail de Remédiation |
|---|-------------------|--------|------------------------|
| 32 | Pseudonymisation SHA-256 des User IDs (**K-30**) | ✅ Validé | Hachage centralisé dans `LogService.setUserId` et `TelemetryService._recordInternal` (toute clé `user.id`/`user_id`/`userid`, pas seulement les appels passant par `AnalyticsService`) |
| 33 | Discrétisation des montants financiers (**K-31**) | ✅ Validé | `TelemetryService._recordInternal` bucket automatiquement toute clé `amount`/`total_amount`/`balance` en `AnalyticsAmountRange`, y compris les appels qui contournaient `AnalyticsService` |
| 34 | Assainissement des messages d'erreur UI (**K-32, K-33**) | ✅ Validé | `ErrorMapper.safeMessage()` appliqué dans `ResellerBloc`, `VoiceBloc` et `AnalyticsBlocObserver` (Crashlytics) |
| 35 | Suppression du Bearer token dans les logs distants (**K-07**) | ✅ Validé | `LogService` n'envoie plus le token en en-tête (remplacé par un `trace_id` opaque) et ne remonte plus `debug`/`info` en release |

---

## 📋 Statut de synthèse

- **33 / 35** points corrigés et vérifiés dans le code (client + backend).
- **1 point ouvert** : K-13 (précision des montants) — nécessite une migration dédiée, hors périmètre d'un correctif ponctuel.
- **1 point partiel** : K-08 — pinning fonctionnel sur Android/API Kauri uniquement ; iOS et la couche Dart cross-plateforme restent à traiter (dépendance tierce ou code natif à valider).
- K-28 (deep link objectif) atténué par validation défensive mais pas signé cryptographiquement — risque résiduel faible, confirmation utilisateur toujours requise.

**Avant la prochaine release production**, statuer explicitement sur K-13 et K-08(iOS) plutôt que de les considérer résolus.

---

*Dernière vérification : 2026-08-24*
*Maintenu par l'équipe Kauri Engineering*
