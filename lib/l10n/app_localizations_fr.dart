// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Kauri';

  @override
  String get dashboard => 'Accueil';

  @override
  String get welcome => 'Bienvenue';

  @override
  String get login => 'Connexion';

  @override
  String get register => 'S\'inscrire';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get forgotPasswordSubtitle =>
      'Entrez votre e-mail pour recevoir un lien de réinitialisation.';

  @override
  String get sendResetLink => 'Envoyer le lien';

  @override
  String get emailSent => 'E-mail envoyé avec succès';

  @override
  String get share => 'Partager';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get noAccount => 'Pas encore de compte ? S\'inscrire';

  @override
  String get alreadyHaveAccount => 'Déjà un compte ? Se connecter';

  @override
  String get transactions => 'Transactions';

  @override
  String get budgets => 'Budgets';

  @override
  String get goals => 'Objectifs';

  @override
  String get challenges => 'Défis';

  @override
  String get coach => 'Coach IA';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Paramètres';

  @override
  String get logout => 'Déconnexion';

  @override
  String get confirmLogout => 'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get cancel => 'Annuler';

  @override
  String get close => 'Fermer';

  @override
  String get edit => 'Modifier';

  @override
  String get editTontine => 'Modifier la tontine';

  @override
  String get none => 'Aucun';

  @override
  String get manageTransactions => 'Gérer mes transactions';

  @override
  String get totalBalance => 'Solde Total';

  @override
  String get recentActivities => 'Activités Récentes';

  @override
  String get noRecentActivities => 'Aucune activité récente';

  @override
  String get seeAll => 'Tout voir';

  @override
  String get addTransaction => 'Ajouter Transaction';

  @override
  String get category => 'Catégorie';

  @override
  String get amount => 'Montant';

  @override
  String get date => 'Date';

  @override
  String get description => 'Description';

  @override
  String get save => 'Enregistrer';

  @override
  String get onboardingTitle1 => 'Bienvenue sur Kauri';

  @override
  String get onboardingDesc1 =>
      'La solution moderne pour gérer vos tontines et épargner ensemble en toute sécurité.';

  @override
  String get onboardingTitle2 => 'Épargne Collective';

  @override
  String get onboardingDesc2 =>
      'Créez ou rejoignez des tontines avec vos proches et suivez les cotisations en temps réel.';

  @override
  String get onboardingTitle3 => 'Sécurité Maximale';

  @override
  String get onboardingDesc3 =>
      'Vos fonds sont protégés et chaque transaction est transparente pour tous les membres.';

  @override
  String get skip => 'Passer';

  @override
  String get start => 'Commencer';

  @override
  String get next => 'Suivant';

  @override
  String get welcomeBack => 'Bon retour !';

  @override
  String get loginSubtitle =>
      'Connectez-vous pour gérer votre tontine digitalisée.';

  @override
  String get emailHint => 'votre@email.com';

  @override
  String get enterEmailError => 'Veuillez entrer votre e-mail';

  @override
  String get invalidEmailError => 'Veuillez entrer un e-mail valide';

  @override
  String get enterPasswordError => 'Veuillez entrer votre mot de passe';

  @override
  String get passwordLengthError =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get genericError => 'Une erreur est survenue';

  @override
  String get retry => 'Réessayer';

  @override
  String get noAccountQuestion => 'Vous n\'avez pas de compte ?';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get registerSubtitle =>
      'Rejoignez Kauri et commencez à épargner intelligemment.';

  @override
  String get firstName => 'Prénom';

  @override
  String get firstNameHint => 'Jean';

  @override
  String get lastName => 'Nom';

  @override
  String get lastNameHint => 'Dupont';

  @override
  String get requiredField => 'Champ requis';

  @override
  String get alreadyHaveAccountQuestion => 'Vous avez déjà un compte ?';

  @override
  String get loginAction => 'Se connecter';

  @override
  String get appSlogan => 'Votre tontine digitalisée';

  @override
  String get myBudgets => 'Mes Budgets';

  @override
  String get noBudgetDefined => 'Aucun budget défini';

  @override
  String get spentLabel => 'Dépensé';

  @override
  String get limitLabel => 'Limite';

  @override
  String get myGoals => 'Mes Objectifs';

  @override
  String get noGoalDefined => 'Aucun objectif défini';

  @override
  String daysRemaining(int count) {
    return '$count jours restants';
  }

  @override
  String daysCount(int count) {
    return '$count jours';
  }

  @override
  String get deadlinePassed => 'Date limite dépassée';

  @override
  String get addTransactionTitle => 'Ajouter Transaction';

  @override
  String get addBudgetTitle => 'Définir Budget';

  @override
  String get addGoalTitle => 'Nouvel Objectif';

  @override
  String get transactionType => 'Type de Transaction';

  @override
  String get expense => 'Dépense';

  @override
  String get income => 'Revenu';

  @override
  String get amountLabel => 'Montant';

  @override
  String get amountHint => '0.00';

  @override
  String get categoryLabel => 'Catégorie';

  @override
  String get categoryHint => 'ex: Alimentation, Salaire...';

  @override
  String get subcategoryLabel => 'Sous-catégorie';

  @override
  String get subcategoryHint => 'ex: Restaurant, Essence...';

  @override
  String get merchantLabel => 'Commerçant';

  @override
  String get merchantHint => 'ex: Casino, Shell...';

  @override
  String get locationLabel => 'Lieu';

  @override
  String get locationHint => 'ex: Douala, Cameroun';

  @override
  String get linkToGoalLabel => 'Lier à un objectif';

  @override
  String get selectGoalHint => 'Sélectionner un objectif (optionnel)';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get descriptionHint => 'ex: Courses du mois';

  @override
  String get monthlyLimitLabel => 'Limite Mensuelle';

  @override
  String get goalNameLabel => 'Nom de l\'objectif';

  @override
  String get goalNameHint => 'ex: Nouveau Téléphone, Voyage...';

  @override
  String get targetAmountLabel => 'Montant Cible';

  @override
  String get deadlineLabel => 'Date Limite';

  @override
  String get saveAction => 'Enregistrer';

  @override
  String get createBudgetAction => 'Créer Budget';

  @override
  String get saveGoalAction => 'Enregistrer';

  @override
  String get successTransaction => 'Transaction ajoutée avec succès';

  @override
  String get errorTransaction => 'Erreur lors de l\'ajout de la transaction';

  @override
  String get successBudget => 'Budget créé avec succès';

  @override
  String get errorBudget => 'Erreur lors de la création du budget';

  @override
  String get successGoal => 'Objectif créé avec succès';

  @override
  String get errorGoal => 'Erreur lors de la création de l\'objectif';

  @override
  String get selectDateError => 'Veuillez sélectionner une date';

  @override
  String get invalidNumber => 'Nombre invalide';

  @override
  String get notifications => 'Notifications';

  @override
  String get security => 'Sécurité';

  @override
  String get language => 'Langue';

  @override
  String get helpSupport => 'Aide & Support';

  @override
  String get theme => 'Thème';

  @override
  String get lightTheme => 'Clair';

  @override
  String get darkTheme => 'Sombre';

  @override
  String get systemTheme => 'Système';

  @override
  String get challengesTitle => 'Défis & Récompenses';

  @override
  String get noChallenges => 'Aucun défi disponible pour le moment';

  @override
  String points(int count) {
    return '$count pts';
  }

  @override
  String get progress => 'Progression';

  @override
  String get finished => 'Terminé';

  @override
  String get acceptChallenge => 'Accepter le défi';

  @override
  String get completed => 'Complété';

  @override
  String get difficulty => 'Difficulté';

  @override
  String get duration => 'Durée';

  @override
  String get reward => 'Récompense';

  @override
  String get startChallenge => 'Commencer le défi';

  @override
  String get validateWeek => 'Valider la semaine';

  @override
  String get yourProgress => 'Votre progression';

  @override
  String percentCompleted(String percent) {
    return '$percent% Complété';
  }

  @override
  String get week => 'Semaine';

  @override
  String get validateWeekTitle => 'Valider la Semaine';

  @override
  String get enterAmountSaved => 'Entrez le montant épargné cette semaine :';

  @override
  String get amountToContribute => 'Montant à verser :';

  @override
  String get confirmValidationTitle => 'Confirmer la validation';

  @override
  String confirmValidationMessage(Object amount) {
    return 'Êtes-vous sûr de vouloir valider cette semaine pour $amount XAF ?';
  }

  @override
  String get confirm => 'Confirmer';

  @override
  String get active => 'Actif';

  @override
  String get coachTitle => 'Coach IA';

  @override
  String get online => 'En ligne';

  @override
  String get coachWelcomeMessage => 'Comment puis-je vous aider aujourd\'hui ?';

  @override
  String get coachThinking => 'L\'IA réfléchit...';

  @override
  String get typeQuestionHint => 'Posez une question...';

  @override
  String get insightsTitle => 'Analyses & Rapports';

  @override
  String get spendingDistribution => 'Répartition des Dépenses';

  @override
  String get spendingTrends => 'Tendances de Dépenses';

  @override
  String get categoryDetails => 'Détails par Catégorie';

  @override
  String get weekly => 'Hebdomadaire';

  @override
  String get monthly => 'Mensuel';

  @override
  String get yearly => 'Annuel';

  @override
  String get noDataAvailable => 'Aucune donnée disponible';

  @override
  String get orContinueWith => 'Ou continuer avec';

  @override
  String get googleSignIn => 'Continuer avec Google';

  @override
  String get appleSignIn => 'Continuer avec Apple';

  @override
  String get phoneLogin => 'Connexion par téléphone';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get enterPhone => 'Entrez votre numéro';

  @override
  String get verify => 'Vérifier';

  @override
  String get enterOtp => 'Entrez le code de vérification';

  @override
  String get otpCode => 'Code SMS';

  @override
  String get resendCode => 'Renvoyer le code';

  @override
  String get phoneLinkedSuccess => 'Téléphone lié avec succès';

  @override
  String get validationSuccess => 'Semaine validée avec succès';

  @override
  String get invalidPhone => 'Numéro de téléphone invalide';

  @override
  String get country => 'Pays';

  @override
  String get selectCountry => 'Sélectionnez votre pays';

  @override
  String get selectCountryError => 'Veuillez sélectionner un pays';

  @override
  String get phoneHint => 'xxxxxxxxx';

  @override
  String get resetSuccess => 'Mot de passe réinitialisé avec succès';

  @override
  String get resetError => 'Erreur lors de la réinitialisation';

  @override
  String get resetPasswordTitle => 'Réinitialiser le mot de passe';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get newPasswordSubtitle =>
      'Créez un mot de passe fort pour sécuriser votre compte.';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get resetPasswordAction => 'Réinitialiser';

  @override
  String get greeting => 'Bonjour,';

  @override
  String get user => 'Utilisateur';

  @override
  String get monthlyIncome => 'Revenu Mensuel';

  @override
  String get totalExpenses => 'Dépenses Totales';

  @override
  String get quickActions => 'Actions Rapides';

  @override
  String get invest => 'Investir';

  @override
  String get insights => 'Analyses';

  @override
  String get importSms => 'Importer SMS';

  @override
  String get featureNotAvailableOnIos =>
      'Fonctionnalité non disponible sur iOS';

  @override
  String get scanningSms => 'Analyse des SMS en cours...';

  @override
  String get automatic => 'Automatique';

  @override
  String transactionsImported(int count) {
    return '$count transactions importées avec succès';
  }

  @override
  String get deleteBudget => 'Supprimer le budget';

  @override
  String get deleteBudgetConfirmation =>
      'Êtes-vous sûr de vouloir supprimer ce budget ?';

  @override
  String get delete => 'Supprimer';

  @override
  String get smsPermissionRequired =>
      'Permission SMS requise pour cette fonctionnalité';

  @override
  String levelLabel(int level) {
    return 'Niveau $level';
  }

  @override
  String xpToNextLevel(int xp) {
    return '$xp XP pour le niveau suivant';
  }

  @override
  String get myInvestments => 'Mes Investissements';

  @override
  String get addInvestment => 'Ajouter Investissement';

  @override
  String get noInvestments => 'Aucun Investissement';

  @override
  String get startBuildingPortfolio => 'Commencez à bâtir votre portefeuille';

  @override
  String get newInvestment => 'Nouvel Investissement';

  @override
  String get investmentDetails => 'Détails de l\'investissement';

  @override
  String get assetNameHint => 'Nom de l\'actif (ex: Bitcoin, Tesla)';

  @override
  String get assetType => 'Type d\'actif';

  @override
  String get investedAmount => 'Montant Investi';

  @override
  String get estimatedROI => 'ROI Estimé (%)';

  @override
  String get cryptoCurrency => 'Cryptomonnaie';

  @override
  String get stockMarket => 'Bourse';

  @override
  String get realEstate => 'Immobilier';

  @override
  String get other => 'Autre';

  @override
  String get fieldRequired => 'Champ requis';

  @override
  String get errorOccurred => 'Une erreur est survenue';

  @override
  String get importGoal => 'Importer Objectif';

  @override
  String get goalImportedSuccess => 'Objectif importé avec succès !';

  @override
  String get sharedGoal => 'Objectif Partagé';

  @override
  String get targetAmount => 'Montant Cible';

  @override
  String get deadline => 'Date Limite';

  @override
  String get addGoalToListPrompt =>
      'Voulez-vous ajouter cet objectif à votre liste ?';

  @override
  String get acceptGoal => 'Accepter l\'objectif';

  @override
  String get aiAnalysisTitle => 'Analyse Financière IA';

  @override
  String get aiAnalysisUnavailable =>
      'L\'analyse IA est temporairement indisponible';

  @override
  String get countryLabel => 'Pays';

  @override
  String get notSet => 'Non défini';

  @override
  String get upgradeToPremium => 'Passer Premium';

  @override
  String get premiumBannerDescription =>
      'Débloquez des analyses avancées, objectifs illimités et support prioritaire.';

  @override
  String get discoverOffers => 'Voir les offres';

  @override
  String get aboutKauri => 'À propos de Kauri';

  @override
  String versionInfo(String version, String buildNumber) {
    return 'Version $version ($buildNumber)';
  }

  @override
  String get aboutDescription =>
      'Kauri est une solution moderne pour gérer vos épargnes et tontines de manière autonome. Notre mission est de démocratiser la gestion financière grâce à la technologie.';

  @override
  String get developedBy => 'Développé avec ❤️ par l\'équipe Kauri';

  @override
  String get contact => 'Contact';

  @override
  String get website => 'Site Web';

  @override
  String get copyrightInfo => '© 2024 Kauri. Tous droits réservés.';

  @override
  String get takePhoto => 'Prendre une photo';

  @override
  String get chooseFromGallery => 'Choisir depuis la galerie';

  @override
  String get receiptScannedSuccess => 'Reçu scanné avec succès';

  @override
  String get receiptScannedError => 'Erreur lors du scan du reçu';

  @override
  String get scanReceiptTooltip => 'Scanner reçu';

  @override
  String get upgradeToPremiumTitle => 'Passez Premium';

  @override
  String get premiumWelcomeTitle => 'Bienvenue dans Premium';

  @override
  String get premiumWelcomeSubtitle =>
      'Profitez de toutes les fonctionnalités avancées';

  @override
  String get freePlan => 'Gratuit';

  @override
  String get freePrice => '0 FCFA';

  @override
  String get freeFeature1 => '3 Budgets max';

  @override
  String get freeFeature2 => '1 Objectif max';

  @override
  String get freeFeature3 => 'Analyses basiques';

  @override
  String get premiumPlan => 'Premium';

  @override
  String get premiumPrice => '2000 FCFA/mois';

  @override
  String get premiumFeature1 => 'Budgets Illimités';

  @override
  String get premiumFeature2 => 'Objectifs Illimités';

  @override
  String get premiumFeature3 => 'Analyses IA Avancées';

  @override
  String get premiumFeature4 => 'Support Prioritaire';

  @override
  String get bestValue => 'Meilleure Offre';

  @override
  String get upgradeAction => 'S\'abonner Maintenant';

  @override
  String get currentPlan => 'Plan Actuel';

  @override
  String get choosePaymentMethodTitle => 'Choisir Méthode de Paiement';

  @override
  String get paymentInitError => 'Erreur d\'initialisation du paiement';

  @override
  String get cameroon => 'Cameroun';

  @override
  String get france => 'France';

  @override
  String get usa => 'États-Unis';

  @override
  String get belgium => 'Belgique';

  @override
  String get canada => 'Canada';

  @override
  String get unjoinChallenge => 'Quitter le défi';

  @override
  String get unjoinConfirmationTitle => 'Quitter le défi';

  @override
  String get unjoinConfirmationMessage =>
      'Êtes-vous sûr de vouloir quitter ce défi ? Votre progression sera perdue.';

  @override
  String get unjoinAction => 'Quitter';

  @override
  String get join => 'REJOINDRE';

  @override
  String get easyDifficulty => 'Facile';

  @override
  String get mediumDifficulty => 'Moyen';

  @override
  String get hardDifficulty => 'Difficile';

  @override
  String get savingType => 'Épargne';

  @override
  String get spendingType => 'Dépense';

  @override
  String get deleteInvestmentConfirmation =>
      'Êtes-vous sûr de vouloir supprimer cet investissement ?';

  @override
  String get budgetDetails => 'Détails du Budget';

  @override
  String get allocated => 'Alloué';

  @override
  String get spent => 'Dépensé';

  @override
  String get remaining => 'Restant';

  @override
  String get categories => 'Catégories';

  @override
  String get goalDescriptionLabel => 'Description';

  @override
  String get goalDescriptionHint => 'ex: Épargne de secours';

  @override
  String get goalTypeLabel => 'Type d\'objectif';

  @override
  String get goalPriorityLabel => 'Priorité';

  @override
  String get goalEmojiLabel => 'Emoji';

  @override
  String get autoSaveRulesTitle => 'Règles d\'Épargne Auto';

  @override
  String get enableSurplusLabel => 'Épargner le surplus';

  @override
  String get enableRoundupLabel => 'Arrondir les transactions';

  @override
  String get percentageIncomeLabel => '% du Revenu';

  @override
  String get emergencyType => 'Urgence';

  @override
  String get savingsType => 'Épargne';

  @override
  String get investmentType => 'Investissement';

  @override
  String get highPriority => 'Haute';

  @override
  String get mediumPriority => 'Moyenne';

  @override
  String get lowPriority => 'Basse';

  @override
  String get deleteGoalConfirmation =>
      'Êtes-vous sûr de vouloir supprimer cet objectif ?';

  @override
  String get strategyLabel => 'Stratégie d\'Épargne';

  @override
  String get strategy_50_30_20 => 'Règle 50-30-20';

  @override
  String get strategy_50_30_20_desc =>
      'Allouez 20% des revenus à l\'épargne (50% besoins, 30% envies).';

  @override
  String get strategy_progressive => 'Progressive';

  @override
  String get strategy_progressive_desc =>
      'Commencez petit et augmentez les contributions avec le temps.';

  @override
  String get strategy_roundup => 'Arrondi';

  @override
  String get strategy_roundup_desc =>
      'Épargnez automatiquement la différence en arrondissant vos dÃ©penses.';

  @override
  String get strategy_pay_yourself_first => 'Se Payer en Premier';

  @override
  String get strategy_pay_yourself_first_desc =>
      'Virement automatique vers l\'épargne dès réception du revenu.';

  @override
  String get strategy_envelope => 'Enveloppe';

  @override
  String get strategy_envelope_desc =>
      'Allouez un montant fixe et arrêtez de dépenser une fois l\'enveloppe vide.';

  @override
  String get strategy_custom => 'Personnalisée';

  @override
  String get strategy_custom_desc =>
      'Contributions flexibles sans règles prédéfinies.';

  @override
  String get addSavingsAction => 'Ajouter Épargne';

  @override
  String get currentAmountLabel => 'Épargné';

  @override
  String get monthAndYear => 'Mois & Année';

  @override
  String get add => 'Ajouter';

  @override
  String get updateAvailable => 'Mise à jour disponible';

  @override
  String get updateRequiredMessage =>
      'Une nouvelle version de Kauri est disponible. Veuillez mettre à jour pour continuer à utiliser l\'application.';

  @override
  String get updateNow => 'Mettre à jour';

  @override
  String get maintenanceMode => 'Mode Maintenance';

  @override
  String get maintenanceMessage =>
      'L\'application est actuellement en maintenance. Veuillez réessayer plus tard.';

  @override
  String get markAllAsRead => 'Tout marquer comme lu';

  @override
  String get noNotifications => 'Aucune notification';

  @override
  String get unknownError => 'Erreur inconnue';

  @override
  String get deleteAccountDescription =>
      'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est définitive et toutes vos données seront perdues.';

  @override
  String get deleteAccountWarning =>
      'Ceci supprimera définitivement votre compte et toutes les données associées.';

  @override
  String get securitySettings => 'Paramètres de Sécurité';

  @override
  String get activeSessions => 'Sessions Actives';

  @override
  String get biometrics => 'Biométrie';

  @override
  String get enableBiometrics => 'Activer la Biométrie';

  @override
  String get biometricsDescription =>
      'Utiliser FaceID ou l\'empreinte digitale pour déverrouiller l\'application';

  @override
  String get dangerZone => 'Zone de Danger';

  @override
  String get currentSession => 'Session Actuelle';

  @override
  String get lastActive => 'Dernière Activité';

  @override
  String get location => 'Lieu';

  @override
  String get changePassword => 'Changer Mot de Passe';

  @override
  String get changePasswordDescription =>
      'Entrez votre mot de passe actuel et le nouveau pour le mettre à jour.';

  @override
  String get currentPassword => 'Mot de passe actuel';

  @override
  String get confirmNewPassword => 'Confirmer nouveau mot de passe';

  @override
  String get updatePassword => 'Mettre à jour';

  @override
  String get passwordTooShort =>
      'Le mot de passe doit faire au moins 6 caractères';

  @override
  String get noSessionsFound => 'Aucune session active trouvée';

  @override
  String get passwordChanged => 'Mot de passe mis à jour avec succès';

  @override
  String get deleteAccount => 'Supprimer le Compte';

  @override
  String get uploadingImage => 'Téléchargement de l\'image...';

  @override
  String get investmentsPremiumRestriction =>
      'L\'accès au portefeuille d\'investissement est réservé aux membres Premium.';

  @override
  String get ocrPremiumRestriction =>
      'Le scan de reçus est réservé aux membres Premium.';

  @override
  String get seeOffers => 'Voir les offres';

  @override
  String get smsImportPremiumRestriction =>
      'L\'import automatique est réservé aux membres Premium.';

  @override
  String get aiAnalysisPremiumRestriction =>
      'Obtenez une analyse détaillée avec le plan Premium.';

  @override
  String get confirmDowngradeTitle => 'Confirmer le déclassement';

  @override
  String get confirmDowngradeMessage =>
      'Êtes-vous sûr de vouloir revenir au plan gratuit ? Les fonctionnalités Premium ne seront plus accessibles.';

  @override
  String get featureTransactions => 'Gestion des Transactions';

  @override
  String get featureBudgetsGoals => 'Budgets & Objectifs';

  @override
  String get featureCoachStandard => 'Coach IA Standard';

  @override
  String get featureGamification => 'Gamification (XP, Badges)';

  @override
  String get featureInvestments => 'Investissements (Bourse, Crypto, Immo)';

  @override
  String get featureOCR => 'OCR / Scan de Reçus';

  @override
  String get featureAIReports => 'Rapports Narratifs IA';

  @override
  String get featureBulkImport => 'Import en Masse (CSV/SMS)';

  @override
  String get revertToFree => 'Revenir au plan gratuit';

  @override
  String get downgradeRequestSuccess =>
      'Votre demande de déclassement a été prise en compte.';

  @override
  String get paymentHistory => 'Historique des Paiements';

  @override
  String get noPaymentFound => 'Aucun paiement trouvé';

  @override
  String get mobileMoney => 'Mobile Money';

  @override
  String get bankCard => 'Carte Bancaire';

  @override
  String mobileMoneyPlatforms(Object price) {
    return 'Orange, MTN, Moov... ($price)';
  }

  @override
  String bankCardPlatforms(Object price) {
    return 'Visa, Mastercard... ($price)';
  }

  @override
  String get invalidAmount => 'Montant invalide';

  @override
  String get french => 'Français';

  @override
  String get english => 'Anglais';

  @override
  String get unknownRenewalDate => 'Date de renouvellement inconnue';

  @override
  String get premiumMember => 'Membre Premium';

  @override
  String expiresOn(Object date) {
    return 'Expire le : $date';
  }

  @override
  String get activeSubscription => 'Abonnement actif';

  @override
  String get subscriptionCancelled => 'Abonnement annulé';

  @override
  String pricePerMonth(Object price) {
    return '$price / mois';
  }

  @override
  String get revokeAllSessions => 'Révoquer toutes les autres sessions';

  @override
  String get revokeSession => 'Révoquer';

  @override
  String get confirmRevokeSession =>
      'Êtes-vous sûr de vouloir révoquer cette session ?';

  @override
  String get confirmRevokeAllSessions =>
      'Êtes-vous sûr de vouloir révoquer toutes les autres sessions ?';

  @override
  String get sessionRevoked => 'Session révoquée avec succès';

  @override
  String get allSessionsRevoked =>
      'Toutes les autres sessions révoquées avec succès';

  @override
  String get termsOfService => 'Conditions d\'Utilisation';

  @override
  String get privacyPolicy => 'Politique de Confidentialité';

  @override
  String get legalSection => 'Légal';

  @override
  String get supportTicketList => 'Tickets de Support';

  @override
  String get createTicket => 'Nouveau Ticket Support';

  @override
  String get ticketSubject => 'Sujet';

  @override
  String get ticketMessage => 'Message';

  @override
  String get ticketCategory => 'Catégorie';

  @override
  String get sendTicket => 'Envoyer Ticket';

  @override
  String get reply => 'Répondre';

  @override
  String get status => 'Statut';

  @override
  String get open => 'Ouvert';

  @override
  String get closed => 'Fermé';

  @override
  String get answered => 'Répondu';

  @override
  String get categoryBug => 'Bug';

  @override
  String get categoryPayment => 'Paiement';

  @override
  String get categoryAccount => 'Compte';

  @override
  String get categoryOther => 'Autre';

  @override
  String get ticketCreatedSuccess => 'Ticket créé avec succès';

  @override
  String get aboutApp => 'À propos de l\'application';

  @override
  String get tutorialGamificationTitle => 'Bienvenue sur votre Dashboard';

  @override
  String get tutorialGamificationDesc =>
      'C\'est ici que vous suivez votre progression, vos points et badges.';

  @override
  String get tutorialBalanceCardTitle => 'Votre Solde Total';

  @override
  String get tutorialBalanceCardDesc =>
      'Visualisez rapidement l\'ensemble de vos avoirs et votre revenu mensuel.';

  @override
  String get tutorialQuickActionsTitle => 'Actions Rapides';

  @override
  String get tutorialQuickActionsDesc =>
      'Ajoutez une transaction, investissez ou consultez vos rapports en un clic.';

  @override
  String get tutorialInsightsTitle => 'Analyse Détaillée';

  @override
  String get tutorialInsightsDesc =>
      'Filtrez par période pour voir votre évolution financière.';

  @override
  String get resetTutorials => 'Réinitialiser les tutoriels';

  @override
  String get resetTutorialsDesc =>
      'Relancez toutes les visites guidées pour revoir comment utiliser l\'application.';

  @override
  String get resetTutorialsConfirm =>
      'Voulez-vous réinitialiser tous les tutoriels ? Ils s\'afficheront à nouveau lors de vos prochaines visites.';

  @override
  String get resetTutorialsSuccess => 'Tutoriels réinitialisés avec succès';

  @override
  String get tutorialChallengesTitle => 'Défis & Objectifs';

  @override
  String get tutorialChallengesDesc =>
      'Relevez des défis pour améliorer votre santé financière.';

  @override
  String get tutorialBudgetsTitle => 'Gestion des Budgets';

  @override
  String get tutorialBudgetsDesc =>
      'Créez et suivez vos limites de dépenses par catégorie.';

  @override
  String get tutorialGoalsTitle => 'Objectifs d\'Épargne';

  @override
  String get tutorialGoalsDesc =>
      'Fixez des projets et suivez votre avancement pour les réaliser.';

  @override
  String get tutorialTransactionsTitle => 'Historique des Transactions';

  @override
  String get tutorialTransactionsDesc =>
      'Consultez le détail de toutes vos entrées et sorties d\'argent.';

  @override
  String get tutorialInvestmentsTitle => 'Vos Investissements';

  @override
  String get tutorialInvestmentsDesc =>
      'Suivez la performance de vos placements et faites fructifier votre argent.';

  @override
  String get tutorialProfileTitle => 'Votre Profil';

  @override
  String get tutorialProfileDesc =>
      'Gérez vos informations personnelles, votre abonnement et vos paramètres.';

  @override
  String get tutorialAddTransactionTitle => 'Ajouter une Transaction';

  @override
  String get tutorialAddTransactionDesc =>
      'Saisissez les détails pour garder un œil sur votre budget.';

  @override
  String get tutorialAddGoalTitle => 'Nouvel Objectif';

  @override
  String get tutorialAddGoalDesc =>
      'Donnez un nom à votre projet et fixez un montant cible.';

  @override
  String get tutorialAddBudgetTitle => 'Nouveau Budget';

  @override
  String get tutorialAddBudgetDesc =>
      'Allouez un montant précis à une catégorie pour ce mois.';

  @override
  String get tutorialAddInvestmentTitle => 'Nouvel Investissement';

  @override
  String get tutorialAddInvestmentDesc =>
      'Diversifiez votre portefeuille en ajoutant un nouvel investissement.';

  @override
  String get tutorialAddTontineTitle => 'Tontine Digitale';

  @override
  String get tutorialAddTontineDesc =>
      'Épargnez ensemble, gérez les tours de rôle et suivez les cotisations avec l\'IA.';

  @override
  String get tutorialOCRTitle => 'Scan de Reçu';

  @override
  String get tutorialOCRDesc =>
      'Utilisez l\'IA pour saisir automatiquement vos transactions à partir de vos photos.';

  @override
  String get tutorialSubscriptionTitle => 'Kauri Premium';

  @override
  String get tutorialSubscriptionDesc =>
      'Découvrez tous les avantages exclusifs pour booster vos finances.';

  @override
  String get confirmCountryChange => 'Confirmer le changement de pays';

  @override
  String get countryChangeWarning =>
      'Changer de pays convertira le solde de votre portefeuille et nécessitera l\'approbation d\'un administrateur. Êtes-vous sûr de vouloir continuer ?';

  @override
  String get completeProfile => 'Compléter le profil';

  @override
  String get completeProfileTitle => 'Dernière étape';

  @override
  String get completeProfileSubtitle =>
      'Veuillez indiquer votre nom pour personnaliser votre expérience.';

  @override
  String get tutorialIncomeTitle => 'Revenu Mensuel';

  @override
  String get tutorialIncomeDesc =>
      'Ajoutez votre revenu pour obtenir des conseils budgétaires personnalisés.';

  @override
  String get updateIncomeTitle => 'Mettre à jour le revenu';

  @override
  String get incomeLabel => 'Montant mensuel';

  @override
  String get countryChangeRequestSubmitted =>
      'Demande de changement de pays soumise avec succès.';

  @override
  String get confirmTransaction => 'Confirmer la transaction';

  @override
  String get recordingInProgress => 'Enregistrement en cours...';

  @override
  String get releaseToFinish => 'Relâchez pour terminer';

  @override
  String voiceExtractionAccuracy(Object percent) {
    return 'Extraction précise à $percent%';
  }

  @override
  String targetGoalLabel(Object goal) {
    return 'Objectif cible : $goal';
  }

  @override
  String get previewRecording => 'Préécouter l\'enregistrement';

  @override
  String get discardRecording => 'Supprimer';

  @override
  String get sendAudio => 'Envoyer l\'audio';

  @override
  String get tontine => 'Tontine';

  @override
  String get createTontine => 'Créer une Tontine';

  @override
  String get noTontineJoined => 'Aucune tontine rejointe';

  @override
  String get startTontineDescription =>
      'Commencez à épargner avec vos amis ou votre famille dès aujourd\'hui.';

  @override
  String get createMyFirstTontine => 'Créer ma première tontine';

  @override
  String get premiumRequired => 'Premium Requis';

  @override
  String get tontinePremiumRestrictionDesc =>
      'La création de plusieurs tontines est réservée aux membres Premium.';

  @override
  String get basicInfo => 'Informations de base';

  @override
  String get tontineName => 'Nom de la tontine';

  @override
  String get contributionAmount => 'Montant de la cotisation';

  @override
  String get frequency => 'Fréquence';

  @override
  String get daily => 'Quotidien';

  @override
  String get rules => 'Règles & Gouvernance';

  @override
  String get totalParts => 'Nombre total de parts';

  @override
  String get rotationMode => 'Mode de rotation';

  @override
  String get manualRotation => 'Manuel';

  @override
  String get randomRotation => 'Aléatoire';

  @override
  String get trustScoreRotation => 'Basé sur le score de confiance';

  @override
  String get validationMode => 'Mode de validation';

  @override
  String get aiOnlyValidation => 'IA uniquement';

  @override
  String get creatorOnlyValidation => 'Créateur uniquement';

  @override
  String get democraticValidation => 'Démocratique (Vote)';

  @override
  String get summary => 'Résumé';

  @override
  String get confirmAndCreate => 'Confirmer et Créer';

  @override
  String get successJoinTontine => 'Tontine rejointe avec succès';

  @override
  String get joinTontine => 'Rejoindre une Tontine';

  @override
  String get enterInviteCode => 'Entrez le code d\'invitation';

  @override
  String get enterInviteCodeDescription =>
      'Saisissez le code fourni par l\'organisateur de la tontine.';

  @override
  String get inviteCode => 'Code d\'invitation';

  @override
  String get joinNow => 'Rejoindre maintenant';

  @override
  String get members => 'Membres';

  @override
  String get chat => 'Chat';

  @override
  String get recentActivity => 'Activité récente';

  @override
  String get noRecentActivity => 'Aucune activité récente';

  @override
  String get collectedAmount => 'Collecté';

  @override
  String get expectedAmount => 'Attendu';

  @override
  String get contributors => 'Contributeurs';

  @override
  String get noMembersFound => 'Aucun membre trouvé';

  @override
  String get contribute => 'Cotiser';

  @override
  String get noMessagesYet => 'Pas encore de messages';

  @override
  String get typeAMessage => 'Tapez un message...';

  @override
  String get successContribution => 'Cotisation envoyée avec succès';

  @override
  String get pendingContributions => 'Cotisations en attente';

  @override
  String get approve => 'Approuver';

  @override
  String get reject => 'Rejeter';

  @override
  String get validation => 'Validation';

  @override
  String get noPendingContributions => 'Aucune cotisation en attente';

  @override
  String get turn => 'Tour';

  @override
  String get displayName => 'Pseudonyme';

  @override
  String get numberOfParts => 'Nombre de parts';

  @override
  String get startTontine => 'Démarrer la tontine';

  @override
  String get confirmStartTontine =>
      'Êtes-vous sûr de vouloir démarrer cette Tontine ?';

  @override
  String get confirmDeleteTontine =>
      'Voulez-vous vraiment supprimer cette tontine ?';

  @override
  String get confirmStopTontine =>
      'Voulez-vous vraiment stopper cette tontine ? Elle passera en statut terminé.';

  @override
  String get stopTontine => 'Stopper la tontine';

  @override
  String get stop => 'Stopper';

  @override
  String get tontineGuideTitle => 'Guide Complet Kauri';

  @override
  String get tontineGuideDesc =>
      'Découvrez comment optimiser votre épargne communautaire.';

  @override
  String get whatIsTontineTitle => 'Le Concept Kauri';

  @override
  String get whatIsTontineDesc =>
      'La tontine est un levier financier puissant. Sur Kauri, nous automatisons la collecte et la redistribution pour une sécurité totale.';

  @override
  String get tontineLifecycleTitle => 'Comprendre les Statuts';

  @override
  String get guidePendingTitle => '1. Recrutement (Pending)';

  @override
  String get guidePendingDesc =>
      'La tontine est créée mais pas encore lancée. Invitez vos amis via le code. Le créateur peut encore modifier les règles (montant, fréquence, etc.).';

  @override
  String get guideActiveTitle => '2. Action (Active)';

  @override
  String get guideActiveDesc =>
      'Le cycle a démarré. À chaque tour, les membres cotisent. L\'argent collecté est versé au bénéficiaire désigné par le mode de rotation.';

  @override
  String get guideCompletedTitle => '3. Archive (Completed)';

  @override
  String get guideCompletedDesc =>
      'Tous les tours sont finis. La tontine reste consultable pour l\'historique des paiements.';

  @override
  String get guideRotationTitle => 'Modes de Rotation';

  @override
  String get guideRotationDesc =>
      '• Fixe : L\'ordre est prédéfini.\n• Aléatoire : La chance décide du gagnant.\n• Enchères/Score : Les membres les plus rigoureux ou ayant besoin de fonds sont prioritaires.';

  @override
  String get guideValidationTitle => 'Transparence & Validation';

  @override
  String get guideValidationDesc =>
      'Fini les disputes ! Notre IA analyse vos reçus de paiement en quelques secondes pour valider vos cotisations.';

  @override
  String get guideSocialFundTitle => 'Solidarité : Fonds Social';

  @override
  String get guideSocialFundDesc =>
      'Une caisse d\'entraide pour les coups durs (maladie, événements familiaux). Ces fonds ne sont pas redistribués automatiquement.';

  @override
  String get guideSanctionsTitle => 'Discipline & Sanctions';

  @override
  String get guideSanctionsDesc =>
      'Pour garantir le succès, des frais de retard ou d\'absence peuvent être appliqués. Un délai de grâce (ex: 24h) est souvent accordé.';

  @override
  String get guideTrustScoreTitle => 'Votre Score de Confiance';

  @override
  String get guideTrustScoreDesc =>
      'C\'est votre réputation financière. Payez à temps pour augmenter votre score et débloquer des avantages dans les futures tontines.';

  @override
  String get tontineStarted => 'Tontine démarrée avec succès';

  @override
  String get invalidAmountError => 'Montant invalide';

  @override
  String get startDate => 'Date de début';

  @override
  String get socialFund => 'Fonds Social';

  @override
  String get enableSocialFund => 'Activer le fonds social';

  @override
  String get sanctions => 'Sanctions';

  @override
  String get lateFee => 'Frais de retard';

  @override
  String get absenceFee => 'Frais d\'absence';

  @override
  String get gracePeriod => 'Période de grâce (heures)';

  @override
  String get paymentAccounts => 'Comptes de paiement';

  @override
  String get addAccount => 'Ajouter un compte';

  @override
  String get accountType => 'Type de compte';

  @override
  String get provider => 'Opérateur/Banque';

  @override
  String get accountNumber => 'Numéro de compte';

  @override
  String get accountName => 'Nom du compte';

  @override
  String get noAccountsAdded => 'Aucun compte ajouté';

  @override
  String get mySubscriptions => 'Mes Abonnements';

  @override
  String get detectSubscriptions => 'Détecter les abonnements';

  @override
  String get noSubscriptionsFound => 'Aucun abonnement trouvé';

  @override
  String get addSubscription => 'Ajouter un abonnement';

  @override
  String get editSubscription => 'Modifier l\'abonnement';

  @override
  String get paymentLabel => 'Paiement :';

  @override
  String get providerLabel => 'Fournisseur';

  @override
  String get nextBillingDateLabel => 'Prochaine facturation';

  @override
  String get trialEndDateLabel => 'Fin de l\'essai gratuit (Optionnel)';

  @override
  String get remindMeLabel => 'M\'alerter avant l\'échéance';

  @override
  String get remindMeSubtitle => 'Recevoir une notification 48h avant';

  @override
  String get subscriptionNameLabel => 'Nom de l\'abonnement';

  @override
  String get subscriptionNameHint => 'ex: Netflix, Spotify...';

  @override
  String get nextInvoices => 'Prochaines Factures';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String inDays(int count) {
    return 'Dans $count jours';
  }

  @override
  String get statusActive => 'Actif';

  @override
  String get statusPaused => 'En pause';

  @override
  String get statusCancelled => 'Annulé';

  @override
  String get statusExpired => 'Expiré';

  @override
  String get frequencyWeekly => 'Hebdomadaire';

  @override
  String get frequencyMonthly => 'Mensuel';

  @override
  String get frequencyYearly => 'Annuel';

  @override
  String get operationSuccess => 'Opération réalisée avec succès';

  @override
  String get alreadyContributed => 'Vous avez déjà cotisé pour ce tour';

  @override
  String get removeMember => 'Retirer un membre';

  @override
  String get howKauriWorks => 'Comment fonctionne Kauri ?';

  @override
  String removeMemberConfirmation(String name) {
    return 'Voulez-vous vraiment retirer $name de cette tontine ?';
  }

  @override
  String get pending => 'En attente';

  @override
  String get history => 'Historique';

  @override
  String get noContributions => 'Aucune contribution';

  @override
  String get remove => 'Retirer';

  @override
  String get tutorialSubscriptionListTitle => 'Vos Abonnements';

  @override
  String get tutorialSubscriptionListDesc =>
      'Consultez et gérez tous vos paiements récurrents ici.';

  @override
  String get tutorialDetectSubscriptionTitle => 'Détection Auto';

  @override
  String get tutorialDetectSubscriptionDesc =>
      'Laissez l\'IA trouver vos abonnements à partir de vos SMS.';

  @override
  String get tutorialAddSubscriptionTitle => 'Ajout Manuel';

  @override
  String get tutorialAddSubscriptionDesc =>
      'Ajoutez un abonnement manuellement s\'il n\'a pas été détecté.';

  @override
  String get tutorialTontineListTitle => 'Vos Tontines';

  @override
  String get tutorialTontineListDesc =>
      'Suivez tous vos groupes de tontine et vos cotisations.';

  @override
  String get tutorialJoinTontineTitle => 'Rejoindre une Tontine';

  @override
  String get tutorialJoinTontineDesc =>
      'Utilisez un code pour rejoindre un groupe existant.';

  @override
  String get tutorialCreateTontineButtonTitle => 'Créer une Tontine';

  @override
  String get tutorialCreateTontineButtonDesc =>
      'Lancez une nouvelle tontine et invitez vos amis.';

  @override
  String get verifyYourEmail => 'Vérifiez votre E-mail';

  @override
  String get verifyEmailDescription =>
      'Un lien de vérification a été envoyé à votre adresse e-mail. Veuillez vérifier votre boîte de réception et cliquer sur le lien pour activer votre compte.';

  @override
  String get backToLogin => 'Retour à la connexion';

  @override
  String get premiumThemes => 'Thèmes Élite (Premium)';

  @override
  String get obsidianGoldThemeLabel => 'Obsidienne & Or';

  @override
  String get polarNightThemeLabel => 'Nuit Polaire';

  @override
  String get sunsetGlowThemeLabel => 'Crépuscule';

  @override
  String get emeraldForestThemeLabel => 'Forêt d\'Émeraude';

  @override
  String get midnightRoyalThemeLabel => 'Royal de Minuit';

  @override
  String get fontFamily => 'Police d\'écriture';

  @override
  String get elegantFont => 'Élégant (Playfair)';

  @override
  String get modernFont => 'Moderne (Poppins)';

  @override
  String get technicalFont => 'Technique (Roboto Mono)';

  @override
  String get classicFont => 'Classique (Outfit)';

  @override
  String get sectionAccount => 'Mon Compte';

  @override
  String get sectionAppearance => 'Apparence';

  @override
  String get sectionLegal => 'Aide & Informations';

  @override
  String get sectionDanger => 'Zone de Danger';
}
