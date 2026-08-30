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

Le pipeline mobile réel est Codemagic, configuré via l'**éditeur visuel** de l'interface codemagic.io (pas de `codemagic.yaml` versionné dans ce dépôt — choix assumé : l'équipe connaît et maîtrise déjà cette configuration, pas de migration vers le mode YAML). Deux workflows attendus, déclenchés respectivement sur push `dev` (staging → build Android + iOS, artefacts publiés sur Slack) et push `main` (production → build + publication Play Store / App Store via Codemagic). **Le détail exact des étapes configurées dans l'éditeur visuel n'est pas dupliqué ici** — il vit dans Codemagic lui-même, seule source de vérité. Voir cependant les points de vigilance ci-dessous, à vérifier directement dans l'éditeur visuel (checklist de mise en place / mise à jour).

**Points à vérifier/mettre à jour dans l'éditeur visuel Codemagic** (indépendants du mode YAML vs UI) :
- **Obfuscation (K-19)** — le champ « Build arguments » / « Additional Flutter build arguments » de l'étape de build Android **et** iOS doit contenir `--obfuscate --split-debug-info=build/symbols/<plateforme>`. Ce n'est pas une case à cocher par défaut — sans ce texte explicite dans le champ, l'obfuscation ne s'applique pas.
- **Variables d'environnement par environnement** — `dart_defines.staging.json`/`dart_defines.prod.json` ne sont **pas** commités (gitignorés, contrairement à `dart_defines.example.json`). Si l'étape de build référence `--dart-define-from-file=dart_defines.staging.json`, ce fichier doit être **recréé pendant le build** — soit via un script Codemagic (section « Scripts », disponible même en mode UI) qui l'écrit depuis une variable d'environnement sécurisée contenant tout le JSON, soit via des `--dart-define=CLE=valeur` individuels déclarés comme variables d'environnement du workflow. Vérifier laquelle des deux approches est en place.
- **Déclencheurs** — confirmer dans l'onglet « Triggering » de chaque workflow que le workflow staging déclenche bien sur push `dev` uniquement, et le workflow production sur push `main` uniquement (pas l'inverse, pas les deux sur la même branche).
- **Publication Play Store / App Store** — dans la section « Publishing », vérifier la piste Google Play utilisée (recommandé : `internal` avec option brouillon, pas `production` directement) et si TestFlight vs soumission App Store publique est cochée. Un déploiement automatique direct vers le grand public à chaque push `main` est un choix à faire consciemment, pas un défaut à subir — cohérent avec le fait que le déploiement production backend n'est lui non plus jamais automatique (voir `djangui-api/DEPLOYMENT.md` § 4.3).
- **Slack** — vérifier dans « Publishing → Slack » que les artefacts (APK/IPA) sont bien joints au message, pas seulement une notification texte.
- **Firebase App Distribution (staging, Android + iOS)** — activer « Publishing → Firebase App Distribution » sur le workflow staging (fonctionnalité native de l'éditeur visuel, pas de script requis) : renseigner l'App ID Firebase Android et l'App ID Firebase iOS (Console Firebase → Paramètres du projet → Vos applications), un groupe de testeurs (ex. `staging-testers`, à créer dans Console Firebase → App Distribution → Testeurs et groupes), et connecter le compte de service Firebase si ce n'est pas déjà fait. Objectif : chaque push sur `dev` doit produire un build installable directement par l'équipe de test, sans étape manuelle après le push.
- **Versioning `YYYYMMDD.N`** — l'éditeur visuel a des champs « Build name »/« Build number » qui acceptent des variables d'environnement calculées par un script préalable. Si ce format n'est pas encore en place, ajouter un script (section « Scripts », avant l'étape de build) qui calcule la date du jour + un numéro de séquence (par ex. en interrogeant les tags Git existants) et exporte le résultat en variable d'environnement, puis référencer cette variable dans les champs Build name/Build number. **Le même format est utilisé côté backend** pour les tags d'image Docker (voir `djangui-api/DEPLOYMENT.md` § 5.2) — dis-le-moi si tu veux le script exact à coller dans la section Scripts.

Les workflows `.github/workflows/*.yml` de ce dépôt (`main.yml`, `build.yml`) restent des vérifications complémentaires légères (`flutter analyze`, SonarQube) — **ils ne construisent ni ne publient jamais de release mobile**, ce rôle appartient entièrement à Codemagic.

### Backend (NodeJS) — GitHub Actions

Dans le dépôt `djangui-api` : `ci.yml` (lint + build + `npm audit`), `build.yml` (analyse SonarQube), `cd.yml` (publication d'image Docker vers GHCR, désormais déclenché sur `main` **et** `dev`, tag versionné `YYYYMMDD.N`), `deploy.yml` (déploiement SSH — staging automatique sur push `main`/`dev`, production uniquement manuelle). Détail complet dans son propre `DEPLOYMENT.md` § 5.

### Monitoring
- **Mobile** — Firebase Crashlytics (crashs), Firebase Analytics, OpenTelemetry (traces, `OTEL_ENDPOINT`), et un endpoint de logs applicatif dédié (`API_LOGS_ENDPOINT`) — voir `dart_defines.example.json`.
- **Backend** — Prometheus/Grafana (99 métriques, dashboard `grafana/dashboards/kauri-api.json`), Graylog, Jaeger — voir `README.md`/`DEPLOYMENT.md` du dépôt `djangui-api` et [grafana_guide_fr.md](grafana_guide_fr.md) côté mobile pour l'interprétation des métriques spécifiques au client.

## 🆘 Support
Pour les problèmes de déploiement, contactez l'équipe DevOps à devops@kauri-app.com.
