# Guide de Déploiement

Ce document explique comment déployer l'application mobile Kauri (Flutter) et son backend (NodeJS).

## 📱 Application Mobile (Flutter)

### 1. Configuration Firebase
- Créez un nouveau projet sur la [Console Firebase](https://console.firebase.google.com/).
- Activez l'**Authentification** (Google, Téléphone).
- Activez **Cloud Messaging** pour les notifications push.
- Téléchargez `google-services.json` (Android) et `GoogleService-Info.plist` (iOS).
- Placez-les respectivement dans `android/app/` et `ios/Runner/`.

### 2. Build & Déploiement Android — local/manuel
- **API Android cible** : `compileSdk = 36` et `targetSdk = 36` sont **écrits en dur** dans `android/app/build.gradle.kts` (exigence Google Play). Ils ne dépendent donc plus de la version de Flutter installée sur la machine ou sur Codemagic. Vérification après un build : le manifeste fusionné (`build/app/intermediates/merged_manifest/release/.../AndroidManifest.xml`) doit contenir `android:targetSdkVersion="36"`.
- **Liens vérifiés (App Links)** : le lien de réinitialisation de mot de passe `https://api.kauri-app.com/reset-password/<jeton>` s'ouvre directement dans l'app (intent-filter `autoVerify`). L'API doit servir `/.well-known/assetlinks.json` — renseigner `ANDROID_SHA256_CERT_FINGERPRINTS` côté API avec l'empreinte du **certificat de signature Play** (Play Console → Intégrité de l'app) *et* celle de la clé d'upload si vous testez des builds locaux.
- **Signature** : Créez un fichier `key.properties` dans `android/` avec le chemin de votre keystore, le mot de passe et l'alias (ne jamais committer ce fichier).
- **Build APK (Release avec Obfuscation - K-19)** :
  ```bash
  flutter build apk --release --dart-define-from-file=dart_defines.prod.json --obfuscate --split-debug-info=build/symbols/android
  ```
- **Build App Bundle (Play Store avec Obfuscation - K-19)** :
  ```bash
  flutter build appbundle --release --dart-define-from-file=dart_defines.prod.json --obfuscate --split-debug-info=build/symbols/android
  ```

### 3. Build & Déploiement iOS — local/manuel
- Ouvrez `ios/Runner.xcworkspace` dans Xcode.
- Configurez « Signing & Capabilities » avec votre équipe de développeurs Apple.
- **Build IPA (Release avec Obfuscation - K-19)** :
  ```bash
  flutter build ipa --release --dart-define-from-file=dart_defines.prod.json --obfuscate --split-debug-info=build/symbols/ios
  ```
- **Universal Links (reset de mot de passe)** : dans le portail développeur Apple, activez la capacité *Associated Domains* sur l'App ID, régénérez le profil de provisioning, puis ajoutez `applinks:api.kauri-app.com` à `com.apple.developer.associated-domains` dans `ios/Runner/Runner.entitlements` (ou via Xcode → Signing & Capabilities). Renseignez `IOS_APP_ID` (`<TEAM_ID>.cm.tbg.kauri`) côté API, qui sert `/.well-known/apple-app-site-association`. Tant que ce n'est pas fait, iOS retombe sur le schéma `kauri://`.
- Conservez l'archive de symboles `build/symbols/` pour la désanonymisation des traces de crash dans Firebase Crashlytics.
- Téléchargez via Transporter ou Xcode vers App Store Connect.

Ces commandes manuelles restent utiles pour du débogage local — **le pipeline réel est celui décrit en § CI/CD ci-dessous, qui exécute exactement ces mêmes flags automatiquement.**

---

## 🖥️ Backend (NodeJS)

Le backend `djangui-api` est un dépôt séparé avec son propre guide de déploiement exhaustif — variables d'environnement complètes (applicatives + infrastructure), les quatre fichiers Docker Compose disponibles, le pipeline CI/CD GitHub Actions réel (`ci.yml`/`cd.yml`/`deploy.yml`/`build.yml`), le bootstrap du premier compte admin, la mise en route du monitoring, et la liste explicite de ce qui n'est pas couvert (TLS, gestionnaire de secrets externe, `docker-compose.prod.yml` à créer). **Ne pas dupliquer cette documentation ici** — se référer directement au `DEPLOYMENT.md`, `ARCHITECTURE.md` et `SECURITY.md` du dépôt `djangui-api`.

Résumé minimal pour développer contre un backend local :
```bash
# Dans le dépôt djangui-api
cp .env.example .env
# Renseigner au minimum : JWT_ACCESS_SECRET, JWT_REFRESH_SECRET,
# VAULT_ENCRYPTION_KEY, MONGODB_URI, GEMINI_API_KEY
docker compose -f docker-compose.dev.yml up --build
```
Le serveur écoute par défaut sur le port **5000** (`PORT`, voir `.env.example`), pas 3000. MongoDB **et** Redis sont tous deux requis (Redis n'est pas optionnel : idempotence des paiements, rate limiting, verrous distribués et liste noire JWT en dépendent) — voir `ARCHITECTURE.md` § 5.

Pour tester depuis un émulateur Android contre ce backend local, utiliser `http://10.0.2.2:5000/api/v1` comme `API_BASE_URL` dans `dart_defines.dev.json` (`10.0.2.2` est l'alias réseau spécial de l'émulateur vers le localhost de la machine hôte).

---

## 🛠️ CI/CD

### Mobile (Flutter) — Codemagic, éditeur visuel

**Répartition (décision 2026-11-12)** : **STAGING = GitHub Actions** (`.github/workflows/android-staging.yml` : après succès de « Mobile CI » sur `dev`, APK release signé, API `https://staging.kauri-app.com/api/v1`, distribué aux testeurs par Firebase App Distribution — secrets requis listés en tête du workflow). **PRODUCTION = Codemagic**, configuré via l'**éditeur visuel** de codemagic.io (pas de `codemagic.yaml` versionné — choix assumé), déclenché sur `main` (build + publication Play Store / App Store). Le workflow `dev` de Codemagic, s'il existe encore, doit être désactivé pour ne pas doubler le staging. **Le détail exact des étapes de l'éditeur visuel n'est pas dupliqué ici** — il vit dans Codemagic, seule source de vérité. Garde-fou côté code : un build de **release** sans `API_BASE_URL`/`ENV` vise désormais la production (`EnvConfig`), mais le workflow de production doit quand même les passer explicitement (voir checklist ci-dessous).

**Points à vérifier/mettre à jour dans l'éditeur visuel Codemagic** (indépendants du mode YAML vs UI) :
- **Obfuscation (K-19)** — le champ « Build arguments » / « Additional Flutter build arguments » de l'étape de build Android **et** iOS doit contenir `--obfuscate --split-debug-info=build/symbols/<plateforme>`. Ce n'est pas une case à cocher par défaut — sans ce texte explicite dans le champ, l'obfuscation ne s'applique pas.
- **Variables d'environnement par environnement** — `dart_defines.staging.json`/`dart_defines.prod.json` ne sont **pas** commités (gitignorés, contrairement à `dart_defines.example.json`). Si l'étape de build référence `--dart-define-from-file=dart_defines.staging.json`, ce fichier doit être **recréé pendant le build** — soit via un script Codemagic (section « Scripts », disponible même en mode UI) qui l'écrit depuis une variable d'environnement sécurisée contenant tout le JSON, soit via des `--dart-define=CLE=valeur` individuels déclarés comme variables d'environnement du workflow. Vérifier laquelle des deux approches est en place.
- **Déclencheurs** — confirmer dans l'onglet « Triggering » de chaque workflow que le workflow staging déclenche bien sur push `dev` uniquement, et le workflow production sur push `main` uniquement (pas l'inverse, pas les deux sur la même branche).
- **Publication Play Store / App Store** — dans la section « Publishing », vérifier la piste Google Play utilisée (recommandé : `internal` avec option brouillon, pas `production` directement) et si TestFlight vs soumission App Store publique est cochée. Un déploiement automatique direct vers le grand public à chaque push `main` est un choix à faire consciemment, pas un défaut à subir — cohérent avec le fait que le déploiement production backend n'est lui non plus jamais automatique (voir `djangui-api/DEPLOYMENT.md` § 4.3).
- **Slack** — vérifier dans « Publishing → Slack » que les artefacts (APK/IPA) sont bien joints au message, pas seulement une notification texte.
- **Firebase App Distribution (staging, Android + iOS)** — activer « Publishing → Firebase App Distribution » sur le workflow staging (fonctionnalité native de l'éditeur visuel, pas de script requis) : renseigner l'App ID Firebase Android et l'App ID Firebase iOS (Console Firebase → Paramètres du projet → Vos applications), un groupe de testeurs (ex. `staging-testers`, à créer dans Console Firebase → App Distribution → Testeurs et groupes), et connecter le compte de service Firebase si ce n'est pas déjà fait. Objectif : chaque push sur `dev` doit produire un build installable directement par l'équipe de test, sans étape manuelle après le push.
- **Versioning `YYYYMMDD.N`** — l'éditeur visuel a des champs « Build name »/« Build number » qui acceptent des variables d'environnement calculées par un script préalable. Si ce format n'est pas encore en place, ajouter un script (section « Scripts », avant l'étape de build) qui calcule la date du jour + un numéro de séquence (par ex. en interrogeant les tags Git existants) et exporte le résultat en variable d'environnement, puis référencer cette variable dans les champs Build name/Build number. **Le même format est utilisé côté backend** pour les tags d'image Docker (voir `djangui-api/DEPLOYMENT.md` § 5.2) — dis-le-moi si tu veux le script exact à coller dans la section Scripts.

Les workflows `.github/workflows/*.yml` de ce dépôt (`main.yml` : `flutter analyze` + `flutter test` sur Flutter 3.47.6) restent des vérifications complémentaires — **ils ne construisent ni ne publient jamais de release mobile**, ce rôle appartient entièrement à Codemagic.

### Backend (NodeJS) — GitHub Actions

Dans le dépôt `djangui-api` : `ci.yml` (lint + format + build + tests + `npm audit` des dépendances de production), `build.yml` (analyse SonarQube, manuelle) et `deploy.yml` (tests → build/push de l'image Docker vers GHCR taguée `YYYYMMDD.N` → déploiement SSH : staging sur push `dev`, production sur push `main`). Détail complet dans son propre `DEPLOYMENT.md` § 5.

### Monitoring
- **Mobile** — Firebase Crashlytics (crashs), Firebase Analytics, OpenTelemetry (traces, `OTEL_ENDPOINT`), et un endpoint de logs applicatif dédié (`API_LOGS_ENDPOINT`) — voir `dart_defines.example.json`.
- **Backend** — Prometheus/Grafana (99 métriques, dashboard `grafana/dashboards/kauri-api.json`), Graylog, Jaeger — voir `README.md`/`DEPLOYMENT.md` du dépôt `djangui-api` et [grafana_guide_fr.md](grafana_guide_fr.md) côté mobile pour l'interprétation des métriques spécifiques au client.

## 🆘 Support
Pour les problèmes de déploiement, contactez l'équipe DevOps à devops@kauri-app.com.

## 🔬 Qualité & SonarQube

Workflow `.github/workflows/main.yml` (chaque PR et push `dev`/`main`) — **la release signée reste construite par Codemagic** :

| Contrôle | Où | Bloquant |
| :-- | :-- | :-- |
| `dart format --set-exit-if-changed` | `quality` | oui |
| `flutter analyze --fatal-infos --fatal-warnings` | `quality` | oui |
| Tests unitaires + widgets + non-régression, couverture, plancher `MIN_COVERAGE` (`tool/check_coverage.sh`) | `test` | oui |
| Compilation Android debug + **non-régression `targetSdk`/`compileSdk` = 36** + App Links du reset de mot de passe | `android-build` | oui |
| gitleaks (`.gitleaks.toml`) + OSV (`pubspec.lock`) | `security` | oui |
| SonarQube (plugin Flutter) + Quality Gate | `sonar` | oui (si secrets définis) |

Secrets GitHub requis : `SONAR_HOST_URL`, `SONAR_TOKEN` (jeton `ci-kauri-mobile`). Le plancher de couverture (`MIN_COVERAGE`, actuellement 2,5 %) est volontairement bas : la couverture initiale est de ~2,7 % — il doit **monter** à chaque PR de tests, jamais baisser.

## 🧱 Toolchain Android — pièges connus

| Symptôme (Codemagic) | Cause | Garde-fou |
| :-- | :-- | :-- |
| `Failed to find target with hash string 'android-37'` | Un plugin exige `compileSdk 37` (ex. `permission_handler_android` 14.x, tiré par `permission_handler` 13.x). L'API 37 s'installe sous `android-37.0`, que AGP 8.11 ne résout pas. | `tool/check_android_plugin_sdk.js` (job `quality`) échoue sur la PR ; Dependabot ignore ces majeures. |
| `Failed to resolve ... 'firebase_core-X' depends on 'flutterfire' X ...` (iOS, SwiftPM) | Plugins FlutterFire à des versions décalées. | Dependabot regroupe `firebase_*` dans une seule PR ; garder la famille alignée (firebase_core 4.15 / auth 6.7 / messaging 16.7 / crashlytics 5.4 / performance 0.11.6). |
| `175 duplicate symbols` / `GoogleDataTransport` (iOS, link) | Un module présent à la fois en SwiftPM (Firebase) et en CocoaPods (ML Kit). | SwiftPM désactivé dans `pubspec.yaml` (`flutter.config.enable-swift-package-manager: false`). À réactiver quand tous les plugins supporteront SwiftPM. |
| `No space left on device` (GitHub Actions) | Build debug 3 ABI sur runner de 14 Go. | Étape de nettoyage + `--target-platform android-arm64`. |

Montée de toolchain : Flutter signale que Gradle 8.14, AGP 8.11 et Kotlin 2.2 seront bientôt abandonnés. À planifier : Gradle ≥ 9.1, AGP ≥ 9.0.1, Kotlin ≥ 2.3.20 — c'est ce qui permettra de réactiver les majeures ignorées ci-dessus.

### Versionnage automatique (production)

Plus aucune version n'est saisie à la main. À chaque fusion `dev` → `main` :

1. « Mobile CI » valide `main`, puis `.github/workflows/release.yml` exécute `tool/release/release.mjs` :
   - version calculée depuis les Conventional Commits depuis le dernier tag : `feat` → mineure, `fix`/autres → correctif, `type!:` ou `BREAKING CHANGE` → majeure ;
   - **édition** : nouvelle constellation (`tool/release/editions.json`) à chaque majeure/mineure, conservée pour un correctif → `v4.1.0 - Orion Edition` ;
   - **build** (versionCode / CFBundleVersion) : max(pubspec, historique, dernier build App Store Connect) + 1 ;
   - fichiers générés : `pubspec.yaml`, `CHANGELOG.md` (FR + EN), `RELEASE_NOTES.md`, `release_notes.json` (notes App Store / Play Store lues par Codemagic), `release/versions.json`, `lib/core/config/app_release.dart` (édition affichée dans « À propos ») ;
   - rédaction FR/EN par Gemini (`GEMINI_API_KEY`), repli automatique sur les messages de commit.
2. Commit `chore(release): …` + tag `vX.Y.Z` sur `main`, puis resynchronisation de `dev`.
3. Le **tag** déclenche le workflow de production Codemagic (déclencheur « tag `v*` »).

Les builds staging (GitHub) utilisent la version publiée + 1 correctif (`4.0.2-staging` sur Android) : l'App Store refuse un nouveau build sur une version déjà publiée.
Essai local sans rien modifier : `node tool/release/release.mjs --dry-run`.
