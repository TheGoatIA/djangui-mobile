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
}
