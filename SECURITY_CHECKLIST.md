# Checklist de Sécurité Mobile — Kauri Financial App

> **Validez cette checklist avant chaque release en production.**
> Chaque item doit être coché par un développeur ET revu par un second pair.

---

## 🔐 Stockage & Secrets

| # | Item | Statut | Responsable |
|---|------|--------|-------------|
| 1 | Tokens d'accès/refresh stockés dans `flutter_secure_storage` (jamais SharedPreferences) | ✅ Implémenté | - |
| 2 | PIN utilisateur stocké via `flutter_secure_storage` avec chiffrement AES | ✅ Implémenté | - |
| 3 | Aucune clé API / secret dans le code source ou les assets | ✅ Via `.env` (ignoré par git) | - |
| 4 | `.env` absent du dépôt git (vérifié dans `.gitignore`) | ✅ Vérifié | - |
| 5 | Base de données SQLite chiffrée avec `sqlcipher_flutter_libs` | ✅ Implémenté | - |
| 6 | `debugPrint` / `print` n'exposent aucun token, montant ou PII en mode release | ⚠️ À vérifier avant release | Dev |

---

## 🌐 Sécurité Réseau

| # | Item | Statut | Responsable |
|---|------|--------|-------------|
| 7 | Certificate Pinning configuré sur les endpoints financiers critiques | ⚠️ À implémenter | Dev |
| 8 | Toutes les communications API en HTTPS uniquement | ✅ Implémenté | - |
| 9 | Timeout réseau configuré (ex : 30s max par requête) | ✅ Vérifié dans interceptors | - |
| 10 | Retry automatique limité (max 3 tentatives) sur erreurs réseau non-financières | ✅ Implémenté | - |
| 11 | Deep links validés — seuls les schémas/hosts autorisés acceptés (`kauri://`) | ✅ Vérifié dans `app_router.dart` | - |

---

## 📱 Sécurité Application

| # | Item | Statut | Responsable |
|---|------|--------|-------------|
| 12 | Root/Jailbreak detection active via FreeRASP (`freerasp`) | ✅ Implémenté dans `main.dart` | - |
| 13 | Anti-tampering & intégrité de l'app vérifiés par FreeRASP | ✅ Implémenté | - |
| 14 | Obfuscation Dart activée en release (`--obfuscate --split-debug-info`) | ⚠️ Vérifier le CI/CD | DevOps |
| 15 | Screenshot prevention active sur les écrans sensibles (FLAG_SECURE Android) | ✅ `SecureScreenMixin` disponible — À appliquer sur chaque écran sensible | Dev |
| 16 | Écrans sensibles utilisant `SecureScreenMixin` : Wallet, TransactionDetail, PIN, KYC, Security | ⚠️ Application manuelle requise | Dev |

---

## 🔑 Authentification & Sessions

| # | Item | Statut | Responsable |
|---|------|--------|-------------|
| 17 | Timeout de session inactivité configuré (> N minutes = déconnexion) | ⚠️ À implémenter dans `AuthBloc` | Dev |
| 18 | Biométrie avec fallback sécurisé (PIN, pas mot de passe système) | ✅ `local_auth` configuré | - |
| 19 | Verrouillage compte après N tentatives échouées (côté serveur + UI) | ✅ Géré côté serveur + tracé | - |
| 20 | Tokens JWT/refresh expirés gèrent le refresh automatique et la déconnexion forcée | ✅ `Authenticator` implémenté | - |
| 21 | Déconnexion vide le cache mémoire des BLoCs (données financières) | ✅ `ClearFintechData` dans `main.dart` | - |

---

## 💳 Transactions & Paiements

| # | Item | Statut | Responsable |
|---|------|--------|-------------|
| 22 | Double confirmation avant toute transaction (résumé + confirmation finale) | ⚠️ À vérifier par flux | Dev |
| 23 | Protection double-tap sur tous les boutons de soumission (`DebouncedButton`) | ✅ Widget disponible — À appliquer | Dev |
| 24 | Montants manipulés en entiers (centimes) — jamais en `double` ou `float` | ⚠️ À auditer dans les models | Dev |
| 25 | Feedback haptique sur validation/erreur de transaction (`FinancialHaptics`) | ✅ Disponible dans `DebouncedButton` | Dev |
| 26 | Historique transactions paginé (jamais chargement total) | ⚠️ À vérifier dans `TransactionBloc` | Dev |

---

## 📊 Analytics & Confidentialité

| # | Item | Statut | Responsable |
|---|------|--------|-------------|
| 27 | Aucun montant exact dans les événements analytics — uniquement `AnalyticsAmountRange` | ✅ `AnalyticsService._sanitize()` filtre | - |
| 28 | `user_id` hashé SHA-256 avant envoi analytics | ✅ `KauriAnalyticsService._hashUserId()` | - |
| 29 | Clés sensibles filtrées automatiquement (`amount`, `phone`, `email`, etc.) | ✅ `_sensitiveKeys` dans `AnalyticsService` | - |
| 30 | Consentement analytics demandé lors de l'onboarding | ⚠️ À vérifier dans `OnboardingPage` | Dev |
| 31 | Option opt-out analytics accessible dans les paramètres | ⚠️ À implémenter | Dev |
| 32 | Aucun log de production contenant des tokens ou données PII | ⚠️ Audit `LogService` avant release | Dev |

---

## 🔔 Notifications Push

| # | Item | Statut | Responsable |
|---|------|--------|-------------|
| 33 | Payloads FCM chiffrés (pas de montants ou noms en clair dans la notification) | ⚠️ À vérifier côté backend | Backend |
| 34 | Deep links des notifications validés avant navigation | ✅ Validé dans `app_router.dart` | - |

---

## 🛡️ Clipboard & Données Partagées

| # | Item | Statut | Responsable |
|---|------|--------|-------------|
| 35 | Auto-clear du clipboard après copie de numéro de compte/IBAN (max 60s) | ⚠️ À implémenter | Dev |
| 36 | Données partagées via `SharePlus` ne contiennent pas de données sensibles | ⚠️ À vérifier dans `ShareService` | Dev |

---

## 🚀 CI/CD & Build

| # | Item | Statut | Responsable |
|---|------|--------|-------------|
| 37 | Build release avec : `flutter build apk --obfuscate --split-debug-info=symbols/` | ⚠️ Vérifier `.github/workflows/build.yml` | DevOps |
| 38 | Symbols uploadés sur Firebase Crashlytics pour déobfuscation des stack traces | ⚠️ À configurer dans CI | DevOps |
| 39 | `debugLogDiagnostics: false` dans `GoRouter` en production | ⚠️ Conditionner sur `kReleaseMode` | Dev |
| 40 | Aucune dépendance avec vulnérabilité connue (Dependabot configuré) | ✅ `.github/dependabot.yml` présent | - |

---

## 📋 Procédure de Validation Release

```
1. [ ] Tous les items "⚠️" ci-dessus traités ou justifiés
2. [ ] Tests de sécurité mobile exécutés (OWASP MASTG checklist)
3. [ ] Review de sécurité pair sur les changements de flux financier
4. [ ] Scan du build avec MobSF ou équivalent
5. [ ] Variables d'environnement production vérifiées
6. [ ] Certificats de signature valides
7. [ ] Firebase App Distribution déployé pour beta test
```

---

*Dernière mise à jour : 2026-03-09*
*Maintenu par l'équipe Kauri Engineering*
