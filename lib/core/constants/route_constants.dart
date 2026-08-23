/// Définition des constantes de navigation (Routes) du projet.
/// Ce fichier centralise tous les noms et chemins de routes pour GoRouter.
class RouteConstants {
  /// Écran d'accueil dynamique (Splash Screen).
  static const String splash = '/';

  /// Écran de connexion par e-mail/mot de passe.
  static const String login = '/login';

  /// Écran d'inscription.
  static const String register = '/register';

  /// Écran de demande de réinitialisation de mot de passe.
  static const String forgotPassword = '/forgot-password';

  /// Écran d'attente de vérification d'email.
  static const String emailVerificationPending = '/email-verification-pending';

  /// Écran de connexion par numéro de téléphone.
  static const String phoneLogin = '/phone-login';

  /// Écran de saisie du code OTP reçu par SMS.
  static const String otpVerification = '/otp-verification';

  /// Écran définitif de réinitialisation du mot de passe.
  static const String resetPassword = '/reset-password';

  /// Route pour l'importation d'un objectif partagé via lien.
  static const String shareGoal = '/share/goal';

  /// Écran de présentation (Onboarding) pour les nouveaux utilisateurs.
  static const String onBoarding = '/onboarding';

  /// Écran principal (Tableau de bord).
  static const String dashboard = '/dashboard';

  /// Liste complète des transactions financières.
  static const String transactions = '/transactions';

  /// Formulaire d'ajout d'une nouvelle transaction.
  static const String addTransaction = '/transactions/add';

  /// Écran de détail d'une transaction spécifique.
  static const String transactionDetails = '/transactions/:id';

  /// Écran de gestion des budgets.
  static const String budgets = '/budgets';

  /// Écran de gestion du portefeuille d'investissements.
  static const String investments = '/investments';

  /// Liste des objectifs d'épargne.
  static const String goals = '/goals';

  /// Détail d'un objectif d'épargne.
  static const String goalDetails = '/goals/:id';

  /// Chat avec le Coach financier IA.
  static const String coach = '/coach';

  /// Écran du profil utilisateur et paramètres personnels.
  static const String profile = '/profile';

  /// Écran des défis et récompenses.
  static const String challenges = '/challenges';

  /// Écran des analyses et rapports financiers détaillés.
  static const String insights = '/insights';

  /// Écran de gestion de l'abonnement Premium.
  static const String subscription = '/subscription';

  /// Espace Revendeur d'abonnements partagés
  static const String resellerHub = '/reseller';

  /// Page d'informations sur l'application.
  static const String about = '/about';

  /// Page Kauri & Argent Réel.
  static const String realMoneyInfo = '/real-money-info';

  /// Centre de notifications.
  static const String notifications = '/notifications';

  /// Paramètres de sécurité (biométrie, sessions).
  static const String security = '/security';

  /// Formulaire de changement de mot de passe.
  static const String changePassword = '/change-password';

  /// Liste des sessions actives du compte.
  static const String sessions = '/sessions';

  /// Page de confirmation de succès après un paiement.
  static const String paymentSuccess = '/payment/success';

  /// Page de signalement d'échec après un paiement.
  static const String paymentFailure = '/payment/failure';

  /// Liste des tickets de support client.

  static const String supportTickets = '/support/tickets';

  /// Formulaire de création d'un ticket de support.
  static const String createTicket = '/support/tickets/create';

  /// Détail d'un ticket de support et chat associé.
  static const String ticketDetails = '/support/tickets/:id';

  /// Écran de finalisation du profil (nom/prénom rattachés).
  static const String completeProfile = '/complete-profile';

  // --- Section Tontines ---
  /// Liste des tontines de l'utilisateur.
  static const String tontines = '/tontines';
  static const String tontineListNamed = 'tontine-list';

  /// Écran de création d'une nouvelle tontine.
  static const String createTontine = '/tontines/create';
  static const String tontineCreateNamed = 'tontine-create';

  /// Détail d'une tontine (membres, cotisations, chat).
  static const String tontineDetails = '/tontines/:id';
  static const String tontineDetailsNamed = 'tontine-details';

  /// Écran pour rejoindre une tontine via un code d'invitation.
  static const String joinTontine = '/tontines/join';
  static const String tontineJoinNamed = 'tontine-join';

  /// Guide d'utilisation des tontines numériques.
  static const String tontineGuide = '/tontines/guide';
  static const String tontineGuideNamed = 'tontine-guide';

  // --- User Subscriptions (Recurring Expenses) ---
  /// Liste des abonnements récurrents détectés ou ajoutés.
  static const String userSubscriptions = '/user-subscriptions';

  /// Formulaire d'ajout manuel d'un abonnement.
  static const String addUserSubscription = '/user-subscriptions/add';

  /// Écran du portefeuille Fintech (Argent réel).
  static const String wallet = '/wallet';

  /// Écran de suspension de compte (Sécurité IA).
  static const String accountSuspended = '/account-suspended';

  /// Écran de soumission KYC (Vérification d'identité).
  static const String kycSubmission = '/kyc-submission';
}
