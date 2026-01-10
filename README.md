# Kauri - Tontine Numérique & Gestion Financière

Kauri est une application mobile moderne, sécurisée et intuitive conçue pour numériser les tontines et offrir aux utilisateurs des outils de gestion financière avancés. Développée avec Flutter, elle offre une expérience fluide pour suivre les épargnes, gérer les budgets et faire fructifier son patrimoine collectivement.

![Kauri Header](https://raw.githubusercontent.com/TheGoatIA/djangui-mobile/main/assets/images/logo.png)

## ✨ Fonctionnalités Clés

- **💰 Tontines Numériques** : Créez ou rejoignez des groupes d'épargne collective avec un suivi transparent des cotisations.
- **🌍 Support Multi-Devises** : Gérez vos finances dans diverses devises (XAF, EUR, USD, etc.) avec conversion automatique des soldes.
- **📊 Budgétisation Avancée** : Définissez des limites mensuelles par catégorie et suivez vos dépenses en temps réel.
- **🎯 Objectifs d'Épargne** : Définissez vos projets, fixez des montants cibles et suivez votre progression avec des stratégies intelligentes.
- **🤖 Coach IA** : Recevez des conseils financiers personnalisés et des analyses propulsés par l'intelligence artificielle.
- **📸 Scan de Reçus (OCR)** : Capturez automatiquement vos transactions en scannant vos reçus.
- **📱 Import SMS** : Importez vos transactions financières directement depuis vos SMS pour un suivi sans effort.
- **🎮 Gamification** : Gagnez de l'XP, des points et des badges en améliorant votre santé financière.
- **🔒 Sécurité Maximale** : Connexion biométrique, gestion des sessions et authentification Firebase sécurisée.

## 🚀 Stack Technique

- **Framework** : [Flutter](https://flutter.dev/)
- **Gestion d'État** : [Bloc/Cubit](https://pub.dev/packages/flutter_bloc)
- **Injection de Dépendances** : [Injectable](https://pub.dev/packages/injectable) / [GetIt](https://pub.dev/packages/get_it)
- **Réseau** : [Chopper](https://pub.dev/packages/chopper)
- **Base de Données** : [Drift](https://pub.dev/packages/drift) (SQLite)
- **Authentification** : Firebase (Google Sign-In, Phone Auth)
- **Localisation** : [flutter_localizations](https://api.flutter.dev/flutter/flutter_localizations-library.html) (EN/FR)
- **Analyses & Suivi** : Firebase Crashlytics & Analytics

## 🛠️ Démarrage Rapide

### Prérequis

- SDK Flutter (Dernière version stable)
- Android Studio / VS Code
- Configuration de projet Firebase

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

3. **Configurer l'environnement** :
   Créez un fichier `.env` à la racine du projet basé sur `.env.example` :
   ```env
   BASE_URL=http://votre-api-backend.com/api/v1
   FIREBASE_API_KEY=votre_cle
   ...
   ```

4. **Lancer l'application** :
   ```bash
   flutter run
   ```

## 📖 Documentation

- [Guide de Déploiement](DEPLOYMENT.md) - Comment déployer l'application mobile et le backend.
- [Contribution](CONTRIBUTING.md) - Comment contribuer au projet.
- [Licence](LICENSE) - Licence MIT.

## 👥 Auteurs

- **L'Équipe Kauri** - *Travail initial* - [TheGoatIA](https://github.com/TheGoatIA)

## 📄 Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE) pour plus de détails.
