# Journal des modifications — Kauri mobile / Changelog

Généré automatiquement à chaque version publiée (`tool/release/release.mjs`). Ne pas modifier à la main.
Automatically generated for each released version. Do not edit by hand.

## v4.1.0 - Orion Edition — 2026-11-15

> Build 39 · 26 commit(s) · version mineure

### 🇫🇷 Français

#### Nouveautés
- vote de clôture, validation des cotisations et suivi organisateur

#### Corrections
- message clair du serveur et pas de NotchPay/Stripe en mode simulation ; code d'erreur Firebase du téléphone
- réparer une base locale illisible au lieu de bloquer la connexion
- SDK reCAPTCHA Enterprise pour la connexion par numéro de téléphone
- connexion Google sur iOS (GIDClientID) et initialisation unique
- Kotlin compilerOptions et envoi TestFlight sans revue Apple
- nom Swift explicite pour SwiftTryCatch (compilation avec les Xcode récents)
- langues FR/EN, thème sombre, navigation et confirmations utilisateur

#### Sécurité
- accepter la signature staging dans freeRASP (builds staging uniquement)

#### Améliorations
- réparation de la base locale isolée et testée (Sonar : style strict, couverture)
- commentaire limité à 80 caractères (Sonar)
- bump the pub-minor-patch group across 1 directory with 31 updates
- Dependabot regroupé (au plus 2 PR par type et par semaine) [skip ci]
- Dependabot mobile regroupé (au plus 2 PR par type et par semaine)

#### Technique
- couverture du refus serveur ; feuille d'abonnement inchangée
- publication Play Store et TestFlight depuis GitHub (remplace Codemagic), notifications Slack homogènes
- bump actions/setup-node
- builds Android/iOS seulement quand le code de l'app change
- lister les problèmes Sonar du nouveau code en cas d'échec
- utiliser Xcode 26 pour le build staging
- journal Xcode détaillé en cas d'échec du build staging
- notifications Slack #deployment (staging Android/iOS, nouvelles versions)
- déclenchement sur push dev avec attente de la CI complète
- afficher les critères du Quality Gate Sonar en échec
- parcours utilisateurs E2E, contrat API et mesure en mode profile
- staging Android/iOS sur GitHub et versionnage automatique des versions

### 🇬🇧 English

#### New features
- vote de clôture, validation des cotisations et suivi organisateur

#### Bug fixes
- message clair du serveur et pas de NotchPay/Stripe en mode simulation ; code d'erreur Firebase du téléphone
- réparer une base locale illisible au lieu de bloquer la connexion
- SDK reCAPTCHA Enterprise pour la connexion par numéro de téléphone
- connexion Google sur iOS (GIDClientID) et initialisation unique
- Kotlin compilerOptions et envoi TestFlight sans revue Apple
- nom Swift explicite pour SwiftTryCatch (compilation avec les Xcode récents)
- langues FR/EN, thème sombre, navigation et confirmations utilisateur

#### Security
- accepter la signature staging dans freeRASP (builds staging uniquement)

#### Improvements
- réparation de la base locale isolée et testée (Sonar : style strict, couverture)
- commentaire limité à 80 caractères (Sonar)
- bump the pub-minor-patch group across 1 directory with 31 updates
- Dependabot regroupé (au plus 2 PR par type et par semaine) [skip ci]
- Dependabot mobile regroupé (au plus 2 PR par type et par semaine)

#### Technical
- couverture du refus serveur ; feuille d'abonnement inchangée
- publication Play Store et TestFlight depuis GitHub (remplace Codemagic), notifications Slack homogènes
- bump actions/setup-node
- builds Android/iOS seulement quand le code de l'app change
- lister les problèmes Sonar du nouveau code en cas d'échec
- utiliser Xcode 26 pour le build staging
- journal Xcode détaillé en cas d'échec du build staging
- notifications Slack #deployment (staging Android/iOS, nouvelles versions)
- déclenchement sur push dev avec attente de la CI complète
- afficher les critères du Quality Gate Sonar en échec
- parcours utilisateurs E2E, contrat API et mesure en mode profile
- staging Android/iOS sur GitHub et versionnage automatique des versions
