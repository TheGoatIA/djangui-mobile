# Checklist de Sécurité Mobile — Kauri Financial App

> **Revue de sécurité post-audit (K-01 à K-41).**
> Statut vérifié ligne par ligne dans le code (client Flutter + API `djangui-api`)
> le 2026-08-24, complétée par une seconde revue le 2026-08-29 (items K-36 à
> K-41, et mise à jour des items K-08, K-09, K-10, K-11, K-13, K-19, K-26, K-28
> marqués **[MàJ 2026-08-29]** ci-dessous) — pas une auto-déclaration. Un point
> reste atténué sans être structurellement résolu, et un autre est à vérifier
> manuellement hors du dépôt (voir synthèse en bas). Revalider cette checklist
> avant chaque release.

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
| 7 | Auto-clear du presse-papier (**K-05, K-27**) | ✅ Validé | **[MàJ 2026-08-29]** Effacement automatique après **30s** (réduit depuis 45s) pour email/mot de passe/PIN du coffre-fort Reseller ; le champ PIN dispose désormais de son propre bouton œil indépendant du champ mot de passe |
| 36 | Jeton biométrique lié matériellement (**K-36**) | ✅ Validé | **[Nouveau 2026-08-29]** `biometric_storage` remplace le stockage `flutter_secure_storage` brut pour le jeton biométrique : le déchiffrement exige une cérémonie biométrique réelle au niveau Keystore (Android, `BiometricPrompt.CryptoObject`) / Keychain (iOS, `kSecAccessControlBiometryCurrentSet`) — un ancien contournement possible (hooker le booléen `local_auth.authenticate()`) ne suffit plus à obtenir le jeton. Le jeton est purgé côté client dès la désactivation de la bascule biométrique dans les réglages. |
| 39 | `allowBackup` désactivé sur Android (**K-39**) | ✅ Validé | **[Nouveau 2026-08-29]** `android:allowBackup="false"` et `android:fullBackupContent="false"` dans `AndroidManifest.xml` — empêche l'extraction des données applicatives (y compris la base SQLite chiffrée et son état) via `adb backup` sur un appareil non verrouillé/en mode debug. |

---

## 🌐 Sécurité Réseau & Intercepteurs

| # | Item / Audit Ref | Statut | Détail de Remédiation |
|---|-------------------|--------|------------------------|
| 8 | Interdiction du trafic HTTP en clair | ✅ Validé | `usesCleartextTraffic="false"` + `network_security_config.xml` |
| 8b | Certificate/SPKI Pinning sur l'API Kauri (**K-08**) | ⚠️ Partiel | **[MàJ 2026-08-29]** Pin-set Android natif réel (intermédiaire + racine Let's Encrypt + feuille courant) via `network_security_config.xml`, toujours le mécanisme le plus solide. **Ajout** : `PinnedHttpOverrides` (`lib/core/network/certificate_pinning.dart`), un `HttpOverrides.global` Dart cross-plateforme qui compare le SHA-256 du certificat SPKI reçu au même pin-set — s'applique donc aussi sur iOS. **Limite documentée honnêtement dans le code** : `dart:io badCertificateCallback` n'est invoqué que si la validation TLS système a déjà échoué — il ne peut donc pas intercepter un certificat émis par une CA que l'OS a été amené à faire confiance (ex. profil MDM/CA d'entreprise malveillante installée), contrairement au pin-set Android natif qui, lui, s'applique indépendamment de la confiance système. iOS reste donc protégé contre un MITM par certificat auto-signé/CA non reconnue, mais pas contre ce cas limite spécifique sans code natif Swift dédié. Domaines de paiement tiers (Stripe/NotchPay) volontairement non épinglés — anti-pattern documenté sur une infra qu'on ne contrôle pas. |
| 9 | Timeout réseau global strict (**K-09**) | ✅ Validé | `TracingHttpClient` : 20s max par requête, tous endpoints ; **[Nouveau 2026-08-29]** flux streaming du Coach IA désormais borné à 30s également (`coach_remote_datasource.dart`), avec message d'erreur explicite au lieu d'un flux qui pouvait rester ouvert indéfiniment |
| 10 | Idempotency-Key sur les endpoints financiers (**K-10**) | ✅ Validé | Intercepteur Dart génère une clé par requête sortante sur withdraw/contribute/redeem/deposit/checkout ; déduplication déjà implémentée côté API (Redis `SET NX`, `src/middleware/idempotency.ts`). **[MàJ 2026-08-29]** Fenêtre de réutilisation de 2 minutes ajoutée côté client (empreinte méthode+chemin+SHA-256 du corps) : un double-tap ou un retry réseau sur une requête identique réutilise la même clé au lieu d'en générer une nouvelle, évitant qu'un simple problème réseau ne déguise un retry légitime en nouvelle opération. |
| 11 | Rejeu de la file hors-ligne sans double-traitement (**K-17**) | ✅ Validé | Clé d'idempotence stable générée à la mise en attente, réutilisée à chaque tentative de rejeu (contribution d'objectif) ; middleware API mis à jour pour lire cette clé depuis le corps de requête |
| 12 | Filtrage des headers sensibles dans les logs réseau (**K-12**) | ✅ Validé | En-tête `Authorization` masqué avant tout `debugPrint` |
| 13 | Masquage des corps de requête sensibles (**K-11**) | ✅ Validé | **[MàJ 2026-08-29]** `/fintech/`, `/payments/`, `/transactions/`, `/reseller/`, `/vault`, et désormais aussi `/goals`, `/tontines`, `/challenges`, `/budgets`, `/reports` masqués (local ET distant) |
| 40 | Authentification de l'endpoint de télémétrie public (**K-40**) | ✅ Validé | **[Nouveau 2026-08-29]** `requireClientApiKey` (backend, `src/middleware/clientApiKey.ts`) vérifie l'en-tête `X-Client-Key` contre `MOBILE_CLIENT_API_KEY` sur `/system/telemetry/:type` — écarte le spam anonyme sur un endpoint jusqu'ici ouvert à tous. Pas un vrai secret (valeur embarquée dans l'app via `LOGS_CLIENT_KEY`, voir `dart_defines.example.json`), fail-open si la variable serveur est absente pour ne pas casser la télémétrie en environnement mal configuré. |

---

## 📱 Sécurité Application, RASP & Code Hardening

| # | Item / Audit Ref | Statut | Détail de Remédiation |
|---|-------------------|--------|------------------------|
| 14 | Détection Root/Jailbreak & RASP active (**K-21**) | ✅ Validé | FreeRASP : menaces critiques (root, hooks, intégrité, émulateur) tuent l'app en release ; menaces ambiguës (matériel sécurisé absent, binding, store non-officiel) journalisées sans bloquer, pour éviter de verrouiller des utilisateurs légitimes |
| 15 | Obfuscation Dart & séparation des symboles (**K-19**) | ⏳ **À vérifier (Codemagic)** | **[MàJ 2026-08-29, x2]** Décision confirmée : l'équipe garde l'**éditeur visuel** Codemagic (pas de migration vers `codemagic.yaml`) — pas de fichier versionné à pointer comme preuve. **Action restante, non automatisable depuis le dépôt** : dans chaque workflow de build (staging et production, Android et iOS), vérifier que le champ « Build arguments »/« Additional Flutter build arguments » contient bien `--obfuscate --split-debug-info=build/symbols/<plateforme>` — ce n'est pas une case à cocher par défaut, sans ce texte explicite l'obfuscation ne s'applique pas silencieusement. Voir `DEPLOYMENT.md` § CI/CD pour la liste complète des points à vérifier dans l'éditeur visuel. |
| 16 | R8 / ProGuard optimisé (**K-20**) | ✅ Validé | `-keep` réduit à `MainActivity` uniquement — le reste du code applicatif est obfusqué |
| 17 | Masquage écran Android (FLAG_SECURE) (**K-23, K-25**) | ✅ Validé | `SecureScreenMixin` appliqué : Wallet, TransactionDetail, Security, OTP, KYC, Reseller Hub, Dashboard, Budgets (liste + création), Goal Detail, Profile. **[MàJ 2026-08-29]** Couverture étendue à Transaction List, Tontine List, Tontine Details, Goal List. PIN du coffre-fort désormais masqué à la saisie, avec son propre bouton œil. |
| 18 | Masquage écran iOS App Switcher (**K-24**) | ✅ Validé | Flou (`UIVisualEffectView`) posé sur toute la fenêtre dans `AppDelegate.swift` lors du passage en arrière-plan — comportement global à l'app, pas seulement aux écrans utilisant le mixin |
| 19 | Désactivation suggestions/autocorrect clavier (**K-26**) | ✅ Validé | `AppTextField` désactive `enableSuggestions`/`autocorrect` par défaut dès que `isPassword: true` ; **[MàJ 2026-08-29]** appliqué explicitement aussi aux champs de `change_password_page.dart` et au dialogue de confirmation de mot de passe de `security_page.dart` |
| 37 | Extension de couverture `SecureScreenMixin` (**K-37**) | ✅ Validé | **[Nouveau 2026-08-29]** Ajouté sur les 4 pages listées à la ligne 17 ci-dessus — ces écrans affichent des montants/soldes/listes financières et n'étaient jusqu'ici pas protégés contre une capture d'écran/enregistrement (Android) en dehors des écrans déjà couverts. |
| 38 | Masquage du solde à l'affichage (**K-38**) | ✅ Validé | **[Nouveau 2026-08-29]** Bascule œil sur le tableau de bord portefeuille (`wallet_dashboard_page.dart`) masquant solde/entrées/sorties (`•••••••`/`•••`), préférence persistée localement (`SharedPreferences`) — permet de consulter l'app en public sans exposer les montants à l'écran, complémentaire du masquage anti-capture (FLAG_SECURE) qui ne protège pas contre un simple regard par-dessus l'épaule. |
| 41 | Suppression de `printenv` du CI mobile (**K-41**) | ✅ Validé | **[Nouveau 2026-08-29]** L'étape `printenv` dans `.github/workflows/build.yml` imprimait l'intégralité des variables d'environnement du runner (dont d'éventuels secrets CI) dans les logs de build, potentiellement accessibles à quiconque a accès aux logs de la CI — retirée. |

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
| 25 | **Précision des montants (K-13)** | 🟡 **Atténué** | **[MàJ 2026-08-29]** Tous les montants restent des `double` (IEEE-754), côté client (Drift `RealColumn`, modèles API) ET côté serveur (Mongoose `Number`) — la migration complète vers un type entier/`Decimal128` reste hors périmètre (choix produit/ingénierie délibéré, voir ci-dessous, inchangé). **Durcissement appliqué en attendant** : un helper `roundAmount = (n) => Math.round(n*100)/100` est désormais appliqué côté serveur à chaque écriture directe d'un champ montant persistant issue d'une addition/soustraction répétée (`goalService.addContribution`/`redeemGoal`/`deleteGoal`, `transactionService` — montants liés à un objectif et `budget.spent`/`totalSpent`, `challengeService` — `week.savedAmount`/`userChallenge.currentValue`) — élimine la dérive d'arrondi visible sur les valeurs affichées sans changer le schéma. **Reste non corrigé** : la précision interne entre deux arrondis, et toute mutation de montant qui serait ajoutée à l'avenir sans passer par ces helpers. **Nécessite toujours une décision produit/ingénierie séparée pour une correction structurelle complète.** |
| 26 | Validation des montants positifs (**K-14 partiel**) | ✅ Validé | `FintechBloc.RequestWithdrawal` rejette les montants `<= 0`, NaN ou infinis |
| 27 | Prévention des doubles soumissions financières (**K-14, K-15**) | ✅ Validé | `droppable()` sur tous les événements BLoC financiers (transactions, budgets, objectifs, tontines, retraits, abonnements) |
| 28 | Rollback optimiste local sur échec serveur (**K-16**) | ✅ Validé | Suppression de l'écriture locale optimiste si le serveur rejette la transaction en ligne |
| 29 | Validation du statut de paiement réel (**K-18**) | ✅ Validé | Écran de succès affiche un échec explicite (pas de faux succès) si aucune référence de transaction n'est fournie |
| 30 | Gestion d'erreur sans fallback fallacieux (**K-34**) | ✅ Validé | Retiré sur les 5 méthodes de lecture tontine (liste, détails, membres, messages, contributions) — un échec serveur ne renvoie plus silencieusement le cache comme un succès |
| 31 | Partage d'objectif — sécurité du mécanisme (**K-28**) | ✅ **Résolu — mécanisme remplacé** | **[MàJ 2026-08-29]** L'ancien mécanisme (lien `kauri://share/goal?data=...` encodant un clone complet de l'objectif, non signé, décodé et affiché côté client) a été **entièrement supprimé** — `ShareService.shareGoal()`/`parseGoalFromToken()` et `goal_import_page.dart` n'existent plus. Remplacé par un vrai objectif **collaboratif** : un code d'invitation court généré côté serveur (`crypto.randomBytes(6)`, CSPRNG), résolu et validé côté serveur (`POST /goals/join`) contre le modèle `GoalParticipant` — **aucune donnée financière n'est plus jamais décodée depuis un lien côté client**, l'objectif entier (montant, échéance, progression) reste servi par l'API comme pour tout autre accès authentifié. Le risque que K-28 documentait (contenu financier falsifiable dans un lien non signé) est donc structurellement éliminé, pas seulement borné en entrée. |

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

- **38 / 41** points corrigés et vérifiés dans le code (client + backend).
- **1 point atténué, non structurel** : K-13 (précision des montants) — arrondi défensif appliqué à chaque écriture serveur connue, mais le schéma reste en `double`/`Number` ; une migration entiers/`Decimal128` reste nécessaire pour une garantie complète et reste hors périmètre d'un correctif ponctuel.
- **1 point partiel** : K-08 — pinning natif fort sur Android, pinning cross-plateforme Dart ajouté (couvre aussi iOS) mais avec une limite structurelle documentée (`badCertificateCallback` ne peut pas intercepter une CA déjà validée par l'OS) ; du code natif Swift resterait nécessaire pour fermer complètement ce cas.
- **1 point à vérifier manuellement, non re-testable depuis le code** : K-19 (obfuscation release) — l'équipe garde l'éditeur visuel Codemagic (pas de fichier versionné), donc la présence des flags `--obfuscate --split-debug-info` doit être confirmée directement dans les réglages de build de chaque workflow avant chaque release.
- K-28 (partage d'objectif) : **résolu structurellement** — l'ancien mécanisme à risque a été remplacé, pas seulement atténué (voir détail ligne 31).

**Avant la prochaine release production**, statuer explicitement sur K-13 et K-08(iOS), et confirmer manuellement K-19 dans Codemagic, plutôt que de les considérer résolus par défaut.

---

*Dernière vérification : 2026-08-24 — complétée le 2026-08-29*
*Maintenu par l'équipe Kauri Engineering*
