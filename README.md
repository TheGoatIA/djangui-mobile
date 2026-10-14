# Kauri - Tontine Numérique & Gestion Financière

Kauri est une application mobile Flutter de finances personnelles assistée par IA : tontines digitales, budgets partagés, objectifs d'épargne collaboratifs, défis d'épargne gamifiés, coach IA, et un hub revendeur. L'application ne fait jamais confiance à ses propres calculs financiers affichés — le backend (`djangui-api`) est la seule source de vérité pour les soldes, taux de change et statuts de paiement.

![Kauri Header](assets/images/logo.png)

**Documentation complète :**
- [DEPLOYMENT.md](DEPLOYMENT.md) — build, signature, variables de compilation, CI/CD (Codemagic)
- [SECURITY_CHECKLIST.md](SECURITY_CHECKLIST.md) — revue de sécurité ligne par ligne, statut par point d'audit
- [PRIVACY_COMPLIANCE.md](PRIVACY_COMPLIANCE.md) — données collectées, rétention, conformité RGPD
- [CONTRIBUTING.md](CONTRIBUTING.md) — standards de code, tests, qualité et procédure de contribution
- [grafana_guide_fr.md](grafana_guide_fr.md) — lecture des métriques mobiles remontées côté serveur

---

## ✨ Fonctionnalités Clés

- **💰 Tontines Numériques** — cotisations tournantes avec suivi des tours, code d'invitation, chat de groupe.
- **📊 Budgétisation Avancée** — enveloppes par catégorie, alertes de dépassement, budgets **partagés** multi-participants, vue "reste à vivre".
- **🎯 Objectifs d'Épargne Collaboratifs** — contribution manuelle ou automatisée (arrondi, % du revenu), plusieurs personnes peuvent contribuer au même objectif via un code d'invitation (le rachat et la suppression restent réservés au créateur).
- **🎮 Défis d'Épargne** — challenges hebdomadaires avec dépôt réel, report/skip limité, résolution automatique.
- **🤖 Coach IA** — conseils financiers conversationnels en streaming, propulsés par Google Gemini.
- **📸 Scan de Reçus (OCR)** & **📱 Import SMS** — capture automatique des transactions.
- **🎮 Gamification** — XP, niveaux, badges liés aux défis complétés.
- **🌍 Multi-Devises** — XAF, EUR, USD... conversion effectuée côté serveur, jamais par le client.
- **🏪 Hub Revendeur** — gestion de slots, coffre-fort de identifiants chiffré, facturation automatisée.

## 🚀 Stack Technique

| Domaine | Technologie |
| :-- | :-- |
| Framework | [Flutter](https://flutter.dev/) / Dart |
| Gestion d'état | [flutter_bloc](https://pub.dev/packages/flutter_bloc) |
| Injection de dépendances | [injectable](https://pub.dev/packages/injectable) / [get_it](https://pub.dev/packages/get_it) |
| Réseau | [Chopper](https://pub.dev/packages/chopper) (intercepteurs auth, idempotence, logging) |
| Base de données locale | [Drift](https://pub.dev/packages/drift) sur **SQLite3MultipleCiphers** (`sqlite3mc`) — base chiffrée au repos, clé aléatoire 256 bits en secure storage |
| Stockage sécurisé | [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) (Keystore Android / Keychain iOS) + [biometric_storage](https://pub.dev/packages/biometric_storage) pour le jeton biométrique (déverrouillage matériel réel, pas une simple vérification booléenne) |
| Protection Runtime (RASP) | [freerasp](https://pub.dev/packages/freerasp) — détection root/jailbreak/hooks/émulateur/débogueur, arrêt de l'app en release sur menace critique |
| Authentification | Firebase (Google Sign-In, téléphone) |
| Localisation | [flutter_localizations](https://api.flutter.dev/flutter/flutter_localizations-library.html) (FR/EN) |
| Suivi & diagnostics | Firebase Crashlytics & Analytics, OpenTelemetry (traces), endpoint de logs applicatif dédié |

## 🛠️ Démarrage Rapide

### Prérequis

- SDK Flutter **3.47.6** (version utilisée par la CI ; Dart ≥ 3.10) — Android : `compileSdk`/`targetSdk` **36** (écrits en dur dans `android/app/build.gradle.kts`, exigence Google Play)
- Android Studio / VS Code
- Projet Firebase configuré (`google-services.json` / `GoogleService-Info.plist`)
- Une instance de l'API backend `djangui-api` accessible (voir son propre `README.md`)

### Installation

1. **Cloner le dépôt** :
   ```bash
   git clone https://github.com/TheGoatIA/djangui-mobile.git
   cd djangui-mobile
   ```

2. **Installer les dépendances** :
   ```bash
   flutter pub get
   ```

3. **Configurer l'environnement — via `--dart-define-from-file`, pas `.env`.**

   ⚠️ Ce projet ne lit **aucun** fichier `.env` au runtime (aucune dépendance `flutter_dotenv` n'est utilisée) — un éventuel fichier `.env` local à la racine est une relique inerte, ignorée par Git, à ne pas utiliser. La configuration réelle passe exclusivement par des fichiers JSON injectés à la compilation :

   ```bash
   cp dart_defines.example.json dart_defines.dev.json
   # Éditer dart_defines.dev.json : API_BASE_URL, OTEL_ENDPOINT,
   # API_LOGS_ENDPOINT, LOGS_CLIENT_KEY, ENV, ENABLE_REAL_MONEY
   ```
   Les fichiers `dart_defines.{dev,staging,prod}.json` sont exclus de Git (secrets/URLs d'environnement) — seul `dart_defines.example.json` est versionné comme référence. `LOGS_CLIENT_KEY` doit avoir la même valeur que `MOBILE_CLIENT_API_KEY` côté backend.

4. **Générer le code (Drift, Injectable, ARB)** :
   ```bash
   flutter gen-l10n
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Lancer l'application** :
   ```bash
   flutter run --dart-define-from-file=dart_defines.dev.json
   ```

Le détail complet des builds release (obfuscation, signature Android/iOS, pipeline Codemagic) est dans [DEPLOYMENT.md](DEPLOYMENT.md).

---

## 🏗️ Architecture

```mermaid
flowchart TD
  UI[Pages / Widgets] --> BLOC[flutter_bloc — états]
  BLOC --> REPO[Repositories]
  REPO --> REMOTE[Datasources distantes<br/>Chopper : auth, idempotence, logging]
  REPO --> LOCAL[(Drift / SQLite3MC chiffré)]
  REMOTE -->|HTTPS + pinning| API[djangui-api]
  ROUTER[go_router + deep_link_parser] --> UI
  LINK[App Links / Universal Links<br/>/reset-password] --> ROUTER
```

- Code organisé par fonctionnalité (`lib/features/<domaine>/{data,domain,presentation}`), noyau transverse dans `lib/core`.
- Les erreurs serveur sont mappées par `lib/core/error/error_mapper.dart` (aucun détail technique n'est montré à l'utilisateur).
- Le lien de réinitialisation `https://api.kauri-app.com/reset-password/<jeton>` ouvre l'app (App Links vérifiés), avec repli sur le schéma `kauri://`.

## ✅ Qualité & CI/CD

```bash
flutter analyze
dart format --output=none --set-exit-if-changed lib test
flutter test --coverage
bash tool/check_coverage.sh
node tool/check_android_plugin_sdk.js 36
```

```mermaid
flowchart LR
  PR[PR / push dev] --> Q[quality<br/>format · analyze · garde-fou SDK]
  PR --> T[test + couverture]
  PR --> A[android-build<br/>APK debug arm64, API 36]
  PR --> S[security<br/>gitleaks · OSV]
  T --> SO[sonar<br/>plugin Flutter]
  main[push main] --> CM[Codemagic<br/>release Android / iOS]
```

- **GitHub Actions** (`.github/workflows/main.yml`) : qualité, tests, compilation Android API 36, sécurité, SonarQube — staging et PR.
- **Codemagic** : uniquement les builds de **production** (signature, obfuscation, stores).
- **Dependabot** hebdomadaire sur `dev` ; plugins FlutterFire groupés (versions alignées), majeures de `permission_handler` ignorées tant que la toolchain n'est pas migrée (voir [DEPLOYMENT.md](DEPLOYMENT.md) § Toolchain Android).

---

## 🔒 Sécurité

Résumé des contrôles principaux — détail exhaustif, statut par point d'audit et éléments encore ouverts dans [SECURITY_CHECKLIST.md](SECURITY_CHECKLIST.md) :

- **RASP** (freerasp) — détection root/jailbreak/hook/débogueur/émulateur, arrêt forcé de l'app en release sur menace critique.
- **Certificate pinning** (Android via `network_security_config.xml` SPKI pin-set ; couverture partielle iOS/Dart — voir limites documentées dans la checklist).
- **Biométrie matérielle** — le jeton de connexion biométrique est chiffré par `biometric_storage`, qui exige une cérémonie biométrique réelle au niveau Keystore/Keychain pour le déchiffrer (pas un simple booléen applicatif contournable).
- **Écran masqué en arrière-plan** — `FLAG_SECURE` (Android) et flou `UIVisualEffectView` (iOS) sur les écrans sensibles (portefeuille, transactions, tontines, objectifs, KYC, OTP, coffre-fort revendeur...).
- **Base de données locale chiffrée** — SQLite3MultipleCiphers, clé aléatoire 256 bits en secure storage.
- **Idempotence côté client** — clé unique par requête financière sortante, avec fenêtre de réutilisation de 2 minutes pour absorber les doubles-taps/retries réseau.
- **Masquage des données sensibles** — corps de requête (finance, objectifs, tontines, défis, budgets, rapports) et en-têtes (`Authorization`) jamais loggés en clair ; pseudonymisation SHA-256 des identifiants utilisateur et discrétisation des montants dans toute la télémétrie.
- **Obfuscation** — `--obfuscate --split-debug-info` sur tous les builds release, vérifié manuellement dans la configuration Codemagic (pas de pipeline GitHub Actions pour les releases — voir [DEPLOYMENT.md](DEPLOYMENT.md)).

Point ouvert le plus important à ce jour : les montants sont stockés en `double` (IEEE-754) côté client **et** serveur — une migration vers un type entier/`Decimal128` est nécessaire pour éliminer tout risque de dérive d'arrondi à long terme, mais nécessite une coordination client/serveur dédiée (voir K-13 dans la checklist).

---

## 👥 Auteurs

- **L'Équipe Kauri** — [TheGoatIA](https://github.com/TheGoatIA)

## 📄 Licence

Ce projet est sous licence MIT — voir [LICENSE](LICENSE).
