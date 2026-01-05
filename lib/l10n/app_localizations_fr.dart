// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Djangui';

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
      'Entrez votre email pour recevoir un lien de réinitialisation.';

  @override
  String get sendResetLink => 'Envoyer le lien';

  @override
  String get emailSent => 'Email envoyé avec succès';

  @override
  String get share => 'Partager';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get noAccount => 'Pas encore de compte ? S\'inscrire';

  @override
  String get alreadyHaveAccount => 'Déjà un compte ? Se connecter';

  @override
  String get dashboard => 'Tableau de bord';

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
  String get totalBalance => 'Solde Total';

  @override
  String get recentActivities => 'Activités Récentes';

  @override
  String get noRecentActivities => 'Aucune activité récente';

  @override
  String get seeAll => 'Voir tout';

  @override
  String get addTransaction => 'Ajouter une transaction';

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
  String get onboardingTitle1 => 'Bienvenue sur Djangui';

  @override
  String get onboardingDesc1 =>
      'La solution moderne pour gérer vos tontines et épargner en groupe en toute sécurité.';

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
  String get enterEmailError => 'Veuillez entrer votre email';

  @override
  String get invalidEmailError => 'Veuillez entrer un email valide';

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
      'Rejoignez Djangui et commencez à épargner intelligemment.';

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
  String get deadlinePassed => 'Echéance passée';

  @override
  String get addTransactionTitle => 'Ajouter une transaction';

  @override
  String get addBudgetTitle => 'Définir un budget';

  @override
  String get addGoalTitle => 'Nouvel Objectif';

  @override
  String get transactionType => 'Type de transaction';

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
  String get descriptionLabel => 'Description';

  @override
  String get descriptionHint => 'ex: Courses du mois';

  @override
  String get monthlyLimitLabel => 'Limite mensuelle';

  @override
  String get goalNameLabel => 'Nom de l\'objectif';

  @override
  String get goalNameHint => 'ex: Nouvel iPhone, Voyage...';

  @override
  String get targetAmountLabel => 'Montant cible';

  @override
  String get deadlineLabel => 'Date d\'échéance';

  @override
  String get saveAction => 'Enregistrer';

  @override
  String get createBudgetAction => 'Créer le budget';

  @override
  String get saveGoalAction => 'Sauvegarder';

  @override
  String get successTransaction => 'Transaction ajoutée avec succès';

  @override
  String get errorTransaction => 'Erreur lors de l\'ajout';

  @override
  String get successBudget => 'Budget créé avec succès';

  @override
  String get errorBudget => 'Erreur lors de la création';

  @override
  String get successGoal => 'Objectif créé avec succès';

  @override
  String get errorGoal => 'Erreur lors de la création';

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
  String get acceptChallenge => 'Relever le défi';

  @override
  String get completed => 'Complété';

  @override
  String get coachTitle => 'Coach IA';

  @override
  String get online => 'En ligne';

  @override
  String get coachWelcomeMessage => 'Comment puis-je vous aider aujourd\'hui ?';

  @override
  String get coachThinking => 'IA réfléchit...';

  @override
  String get typeQuestionHint => 'Posez votre question...';

  @override
  String get insightsTitle => 'Analyses & Rapports';

  @override
  String get spendingDistribution => 'Répartition des Dépenses';

  @override
  String get spendingTrends => 'Tendance des Dépenses';

  @override
  String get categoryDetails => 'Détail par Catégorie';

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
  String get phoneLogin => 'Connexion par numéro';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get enterPhone => 'Entrez votre numéro';

  @override
  String get verify => 'Vérifier';

  @override
  String get enterOtp => 'Entrez le code reçu';

  @override
  String get otpCode => 'Code SMS';

  @override
  String get resendCode => 'Renvoyer le code';

  @override
  String get phoneLinkedSuccess => 'Numéro lié avec succès';

  @override
  String get invalidPhone => 'Numéro invalide';

  @override
  String get country => 'Pays';

  @override
  String get selectCountry => 'Sélectionnez votre pays';

  @override
  String get selectCountryError => 'Veuillez sélectionner un pays';

  @override
  String get phoneHint => '+237 6xx xxx xxx';

  @override
  String get resetSuccess => 'Mot de passe réinitialisé avec succès';

  @override
  String get resetError => 'Erreur lors de la réinitialisation';

  @override
  String get resetPasswordTitle => 'Réinitialisation';

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
  String get resetPasswordAction => 'Réinitialiser le mot de passe';

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
  String get importSms => 'Import SMS';

  @override
  String get scanningSms => 'Recherche de transactions SMS...';

  @override
  String get automatic => 'Automatique';

  @override
  String transactionsImported(int count) {
    return '$count transactions importées !';
  }

  @override
  String get smsPermissionRequired =>
      'Permission SMS requise pour cette fonctionnalité';

  @override
  String levelLabel(int level) {
    return 'Niveau $level';
  }

  @override
  String xpToNextLevel(int xp) {
    return '$xp XP pour le prochain niveau';
  }

  @override
  String get myInvestments => 'Mes Investissements';

  @override
  String get addInvestment => 'Ajouter un investissement';

  @override
  String get noInvestments => 'Aucun investissement';

  @override
  String get startBuildingPortfolio =>
      'Commencez à construire votre portefeuille';

  @override
  String get newInvestment => 'Nouvel Investissement';

  @override
  String get investmentDetails => 'Détails de l\'investissement';

  @override
  String get assetNameHint => 'Nom de l\'actif (ex: Bitcoin, Tesla)';

  @override
  String get assetType => 'Type d\'actif';

  @override
  String get investedAmount => 'Montant investi';

  @override
  String get estimatedROI => 'ROI estimé (%)';

  @override
  String get cryptoCurrency => 'Crypto-monnaie';

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
  String get importGoal => 'Importer un objectif';

  @override
  String get goalImportedSuccess => 'Objectif importé avec succès !';

  @override
  String get sharedGoal => 'Objectif Partagé';

  @override
  String get targetAmount => 'Montant cible';

  @override
  String get deadline => 'Date limite';

  @override
  String get addGoalToListPrompt =>
      'Voulez-vous ajouter cet objectif à votre liste ?';

  @override
  String get acceptGoal => 'Accepter l\'objectif';

  @override
  String get aiAnalysisTitle => 'Analyse Financière par IA';

  @override
  String get aiAnalysisUnavailable =>
      'L\'analyse par IA est actuellement indisponible';

  @override
  String get countryLabel => 'Pays';

  @override
  String get notSet => 'Non renseigné';

  @override
  String get upgradeToPremium => 'Passer au Premium';

  @override
  String get premiumBannerDescription =>
      'Débloquez des analyses avancées, des objectifs illimités et un support prioritaire.';

  @override
  String get discoverOffers => 'Découvrir les offres';

  @override
  String get aboutDjangui => 'À propos de Djangui';

  @override
  String versionInfo(String version, String buildNumber) {
    return 'Version $version ($buildNumber)';
  }

  @override
  String get aboutDescription =>
      'Djangui est une solution moderne pour gérer votre épargne et vos tontines en toute autonomie. Notre mission est de démocratiser la gestion financière via la technologie.';

  @override
  String get developedBy => 'Développé avec ❤️ par l\'équipe Djangui';

  @override
  String get contact => 'Contact';

  @override
  String get website => 'Site web';

  @override
  String get copyrightInfo => '© 2024 Djangui. Tous droits réservés.';

  @override
  String get takePhoto => 'Prendre une photo';

  @override
  String get chooseFromGallery => 'Choisir depuis la galerie';

  @override
  String get receiptScannedSuccess => 'Reçu scanné avec succès';

  @override
  String get receiptScannedError => 'Erreur lors du scan du reçu';

  @override
  String get scanReceiptTooltip => 'Scanner un reçu';

  @override
  String get upgradeToPremiumTitle => 'Passer au Premium';

  @override
  String get premiumWelcomeTitle => 'Bienvenue au Premium';

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
  String get premiumFeature1 => 'Budgets illimités';

  @override
  String get premiumFeature2 => 'Objectifs illimités';

  @override
  String get premiumFeature3 => 'Analyses IA avancées';

  @override
  String get premiumFeature4 => 'Support prioritaire';

  @override
  String get bestValue => 'Meilleure offre';

  @override
  String get upgradeAction => 'S\'abonner maintenant';

  @override
  String get currentPlan => 'Plan actuel';

  @override
  String get choosePaymentMethodTitle => 'Choisir le mode de paiement';

  @override
  String get paymentInitError => 'Erreur lors de l\'initialisation du paiement';

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
}
