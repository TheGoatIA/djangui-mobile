# 🚀 Kauri - Gestion Financière Intelligente

Kauri est une application mobile de gestion financière moderne, conçue pour aider les utilisateurs à épargner, investir et gérer leurs tontines de manière intelligente et sécurisée. L'application utilise une architecture Clean, un design system propriétaire et des fonctionnalités d'IA pour une expérience utilisateur premium.

---

## 📋 Sommaire
- [Architecture](#-architecture)
- [Prérequis](#-prérequis)
- [Installation local](#-installation-local)
- [Configuration Firebase](#-configuration-firebase)
- [CI/CD & Déploiement](#-cicd--déploiement)
- [Rebranding & Identité](#-rebranding--identité)
- [Contribution](#-contribution)

---

## 🏗 Architecture
L'application suit les principes de la **Clean Architecture** pour assurer la maintenabilité et la testabilité :
- **Data** : Sources de données (API, SQLite avec Drift, Local Storage).
- **Domain** : Entités métiers et interfaces des dépôts (Logique pure).
- **Presentation** : Gestion d'état avec BLoC et composants UI Material 3.
- **Core** : Thèmes, constantes, utilitaires et configuration réseau.

---

## 🛠 Prérequis
Avant de commencer, assurez-vous d'avoir installé :
- **Flutter SDK** : `3.10.1` ou supérieur.
- **Dart SDK** : `^3.10.1`.
- **Java** : JDK 17 (Nécessaire pour le build Android).
- **CocoaPods** : Pour les dépendances iOS (`sudo gem install cocoapods`).
- **Android Studio / Xcode** : Pour l'émulation et le build natif.

---

## 💻 Installation Local

1.  **Cloner le projet** :
    ```bash
    git clone https://github.com/votre-repo/Kauri.git
    cd Kauri
    ```

2.  **Installer les dépendances** :
    ```bash
    flutter pub get
    ```

3.  **Configurer les variables d'environnement** :
    Créez un fichier `.env` à la racine du projet (copiez `.env.example`) :
    ```bash
    API_URL=https://votre-api.com
    # Ajoutez vos autres clés secrètes ici
    ```

4.  **Générer le code** (Drift, Chopper, Injectable) :
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

5.  **Lancer l'application** :
    ```bash
    flutter run
    ```

---

## 🔥 Configuration Firebase

### Android
1. Allez sur la [Console Firebase](https://console.firebase.google.com/).
2. Ajoutez un projet Android avec le package `cm.tbg.Kauri`.
3. Téléchargez le fichier `google-services.json` et placez-le dans `android/app/`.
4. Le projet est déjà configuré pour lire ce fichier.

### iOS
1. Ajoutez une application iOS au projet Firebase avec l'ID `cm.tbg.Kauri`.
2. Téléchargez `GoogleService-Info.plist` et ajoutez-le au projet via Xcode dans `Runner/`.
3. Assurez-vous que le fichier est bien inclus dans la cible "Runner".

---

## 🚀 CI/CD & Déploiement

Le projet utilise **GitHub Actions** pour automatiser les tests et les builds.

- **Workflows** : Situés dans `.github/workflows/main.yml`.
- **Lint & Test** : Exécutés à chaque push sur `main` ou `dev`.
- **Build APK** : Stocké comme artefact après succès des tests.
- **Build IPA** : Préparé pour iOS (nécessite signature manuelle pour l'App Store).

### Déploiement Manuel
- **Android** : `flutter build apk --release`
- **iOS** : `flutter build ios --release --no-codesign`

---

## 🏷 Rebranding & Identité
- **Nom du Package** : `cm.tbg.Kauri`
- **Nom de l'App** : `Kauri`
- **Logo** : Stocké dans `assets/images/logo.png`.
- Pour régénérer les icônes :
  ```bash
  flutter pub run flutter_launcher_icons:main
  ```

---

## 🤝 Contribution
1. Créez une branche depuis `dev` (`git checkout -b feature/ma-feature`).
2. Suivez les templates d'Issue et de Pull Request fournis dans `.github/`.
3. Assurez-vous que `flutter analyze` ne retourne aucune erreur.
4. Soumettez votre PR vers `dev`.

---

## 📧 Support
Pour toute question, contactez l'équipe TBG ou soumettez une Issue sur le repository.

---
*Fabriqué avec ❤️ pour une gestion financière d'exception.*
