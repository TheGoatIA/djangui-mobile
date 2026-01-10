# Guide de Déploiement

Ce document explique comment déployer l'application mobile Kauri (Flutter) et son backend (NodeJS).

## 📱 Application Mobile (Flutter)

### 1. Configuration Firebase
- Créez un nouveau projet sur la [Console Firebase](https://console.firebase.google.com/).
- Activez l'**Authentification** (Google, Téléphone).
- Activez **Cloud Messaging** pour les notifications push.
- Téléchargez `google-services.json` (Android) et `GoogleService-Info.plist` (iOS).
- Placez-les respectivement dans `android/app/` et `ios/Runner/`.

### 2. Build & Déploiement Android
- **Signature** : Créez un fichier `key.properties` dans `android/` avec le chemin de votre keystore, le mot de passe et l'alias.
- **Build APK** :
  ```bash
  flutter build apk --release
  ```
- **Build App Bundle** (pour le Play Store) :
  ```bash
  flutter build appbundle --release
  ```

### 3. Build & Déploiement iOS
- Ouvrez `ios/Runner.xcworkspace` dans Xcode.
- Configurez « Signing & Capabilities » avec votre équipe de développeurs Apple.
- **Build IPA** :
  ```bash
  flutter build ipa --release
  ```
- Téléchargez via Transporter ou Xcode vers App Store Connect.

---

## 🖥️ Backend (NodeJS)

### 1. Prérequis
- Node.js v18+
- Instance MongoDB (Atlas ou locale)
- Redis (Optionnel, pour le cache/sessions)
- Docker & Docker Compose (Recommandé)

### 2. Configuration de l'Environnement
Créez un fichier `.env` à la racine du backend :
```env
PORT=3000
MONGODB_URI=mongodb+srv://...
JWT_SECRET=votre_secret_jwt
FIREBASE_PROJECT_ID=djangui-9872c
FIREBASE_SERVICE_ACCOUNT=chemin/vers/serviceAccountKey.json
STRIPE_SECRET_KEY=sk_test_...
NOTCHPAY_PUBLIC_KEY=...
```

### 3. Déploiement avec Docker (Recommandé)
1. **Docker Compose** :
   ```bash
   docker-compose up -d --build
   ```
   Cela lancera les conteneurs API et MongoDB.

### 4. Déploiement Manuel
1. **Installer les dépendances** :
   ```bash
   npm install
   ```
2. **Builder le projet** :
   ```bash
   npm run build
   ```
3. **Démarrer avec PM2** :
   ```bash
   pm2 start dist/app.js --name kauri-api
   ```

---

## 🛠️ Infrastructure & CI/CD

### GitHub Actions
Le projet inclut des workflows pour :
- **CI** : Tests automatisés et analyse à chaque push.
- **CD** : Déploiement vers Firebase Distribution ou les stores Play/App.

### Monitoring
- **Suivi des Erreurs** : Utilise Firebase Crashlytics pour le mobile.
- **Logs API** : Accessibles via `docker logs kauri-api` ou votre service de logs.

## 🆘 Support
Pour les problèmes de déploiement, contactez l'équipe DevOps à devops@kauri-app.com.
