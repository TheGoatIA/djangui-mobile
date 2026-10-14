/// Documentation des constantes d'API pour l'application Kauri.
/// Ce fichier centralise tous les points de terminaison (endpoints) utilisés par les services distants.
class ApiConstants {
  // Remarque : baseUrl est fourni par EnvConfig.apiBaseUrl (voir core/config/env_config.dart).

  // --- Authentification ---
  /// Point de terminaison pour la connexion utilisateur.
  static const String login = '/auth/login';

  /// Point de terminaison pour l'inscription d'un nouvel utilisateur.
  static const String register = '/auth/register';

  /// Chemin pour rafraîchir le jeton d'accès (access token).
  static const String refresh = '/auth/refresh';

  /// Chemin pour la déconnexion de l'utilisateur.
  static const String logout = '/auth/logout';

  /// Authentification via Firebase (Google, Phone, etc.).
  static const String firebaseAuth = '/auth/firebase';

  /// Authentification via le service Sign in with Apple.
  static const String appleAuth = '/auth/apple';

  /// Lier un numéro de téléphone à un compte existant.
  static const String linkPhone = '/auth/link-phone';

  /// Mise à jour du jeton Firebase Cloud Messaging (FCM).
  static const String fcmToken = '/auth/fcm-token';

  /// Demande de réinitialisation de mot de passe oublié.
  static const String forgotPassword = '/auth/forgot-password';

  /// Réinitialisation effective du mot de passe.
  static const String resetPassword = '/auth/reset-password';

  /// Vérification d'e-mail via jeton.
  static const String verifyEmail = '/auth/verify-email';

  /// Récupération des informations du profil de l'utilisateur connecté.
  static const String me = '/auth/me';

  /// Changement du mot de passe utilisateur.
  static const String changePassword = '/auth/change-password';

  /// Suppression définitive du compte utilisateur.
  static const String deleteMe = '/auth/delete-me';

  /// Liste des sessions actives de l'utilisateur.
  static const String sessions = '/auth/sessions';

  /// Journalisation des connexions (historique).
  static const String connection = '/auth/connection';

  /// Requête administrative pour changer de pays de résidence.
  static const String requestCountryChange = '/auth/request-country-change';

  /// Mise à jour de la préférence linguistique de l'utilisateur.
  static const String updateLanguage = '/auth/language';

  // --- Transactions ---
  /// Gestion des transactions financières.
  static const String transactions = '/transactions';

  /// Importation groupée de transactions.
  static const String transactionsBulk = '/transactions/bulk';

  // --- Budgets ---
  /// Gestion des budgets.
  static const String budgets = '/budgets';

  /// Récupération du budget en cours pour la période actuelle.
  static const String budgetsCurrent = '/budgets/current';

  // --- Objectifs (Goals) ---
  /// Gestion des objectifs d'épargne.
  static const String goals = '/goals';

  // --- IA & Automatisation ---
  /// Scan OCR pour l'extraction de données de reçus.
  static const String ocrScan = '/ocr/scan';

  /// Analyse d'un SMS unique pour extraire des transactions.
  static const String smsParse = '/sms/parse';

  /// Analyse groupée de SMS historiques.
  static const String smsBulkParse = '/sms/bulk-parse';

  /// Traitement des commandes vocales par l'IA.
  static const String voiceProcess = '/voice/process';

  // --- Rapports (Reports) ---
  /// Données consolidées pour le tableau de bord principal.
  static const String reportDashboard = '/reports/dashboard';

  /// Analyses financières détaillées.
  static const String reportAnalysis = '/reports/analysis';

  /// Rapports narratifs générés par l'IA (insights).
  static const String reportNarrative = '/reports/narrative';

  // --- Investissements ---
  /// Gestion du portefeuille d'investissements.
  static const String investments = '/investments';

  // --- Défis (Challenges) ---
  /// Liste des défis financiers disponibles.
  static const String challenges = '/challenges';

  /// Liste des défis auxquels l'utilisateur est inscrit.
  static const String myChallenges = '/challenges/my-challenges';

  /// Validation d'une étape hebdomadaire d'un défi.
  static const String validateWeek = '/challenges/validate-week';

  // --- Téléchargements (Upload) ---
  /// Importation de fichiers de reçus/factures.
  static const String uploadReceipt = '/upload/receipt';

  /// Mise à jour de la photo de profil.
  static const String uploadAvatar = '/upload/avatar';

  // --- Paiements & Abonnements ---
  /// Initialisation d'un paiement via la passerelle NotchPay.
  static const String notchPayInit = '/payments/init/notchpay';

  /// Création d'une session de paiement Stripe.
  static const String stripeCheckout = '/payments/checkout/stripe';

  /// Vérification du statut d'un paiement via sa référence.
  static const String verifyPayment = '/payments/verify/{reference}';
  static String verifyPaymentUrl(String reference) =>
      '/payments/verify/$reference';

  /// Historique des transactions de paiement.
  static const String paymentHistory = '/payments';

  /// Annulation d'un abonnement Premium actif.
  static const String cancelSubscription = '/payments/cancel-subscription';

  /// Paiement de l'abonnement Premium directement via le portefeuille Kauri.
  static const String paySubscriptionWallet = '/payments/pay/wallet';

  // --- Notifications ---
  /// Gestion des notifications utilisateur.
  static const String notifications = '/notifications';

  /// Marquer toutes les notifications comme lues.
  static const String notificationsMarkRead = '/notifications/mark-all-read';

  /// Récupération du nombre de notifications non lues.
  static const String notificationsUnreadCount = '/notifications/unread-count';

  // --- Support ---
  /// Gestion des tickets de support technique.
  static const String supportTickets = '/support/tickets';

  // --- Fintech & KYC ---
  /// Soumission des documents KYC.
  static const String kycSubmit = '/fintech/kyc/submit';

  /// Récupération du solde du portefeuille.
  static const String walletBalance = '/fintech/wallet/balance';

  /// Historique des transactions du portefeuille.
  static const String walletTransactions = '/fintech/wallet/transactions';

  /// Demande de retrait (Payout).
  static const String withdraw = '/fintech/payout/withdraw';

  // --- IA Coach & Premium ---
  /// Poser une question au coach IA.
  static const String coachAsk = '/coach/ask';

  /// Récupération du budget automatique (Premium).
  static const String premiumAutoBudget = '/premium/auto-budget';

  /// Récupération du rapport narratif (Premium).
  static const String premiumReport = '/premium/report';

  // --- Tontines ---
  /// Gestion des groupes de tontine.
  static const String tontines = '/tontines';

  /// Rejoindre un groupe de tontine existant.
  static const String tontinesJoin = '/tontines/join';

  /// Soumettre une cotisation à une tontine.
  static const String tontinesContribute = '/tontines/contribute';

  /// Liste des membres d'une tontine.
  static const String tontineMembers = '/tontines/{id}/members';

  /// Liste des messages d'une tontine.
  static const String tontineMessages = '/tontines/{id}/messages';

  /// Liste des cotisations pour une tontine spécifique.
  static const String tontineContributions = '/tontines/{id}/contributions';

  /// Validation administrative d'une contribution.
  static const String validateContribution =
      '/tontines/contributions/{id}/validate';

  // --- Système ---
  /// Configuration publique du système (versions, maintenance).
  static const String publicSettings = '/system/public-settings';

  // --- Abonnements Externe (Recurring Expenses) ---
  /// Gestion des abonnements récurrents détectés (Netflix, Spotify, etc.).
  static const String subscriptions = '/subscriptions';

  /// Configuration dynamique et tarifs des forfaits Kauri (Free, Premium, Business).
  static const String subscriptionPlans = '/subscriptions/plans';

  /// Détection automatique d'abonnements via les données SMS.
  static const String subscriptionsDetect = '/subscriptions/detect';

  // --- Analyses (Analytics) ---
  /// Envoi de données analytiques globales.
  static const String analytics = '/analytics';

  /// Journalisation d'événements spécifiques dans l'application.
  static const String analyticsEvents = '/analytics/events';

  /// Enregistre le début d'une session utilisateur.
  static const String analyticsSessionStart = '/analytics/sessions/start';

  /// Enregistre la fin d'une session utilisateur.
  static const String analyticsSessionEnd = '/analytics/sessions/end';
}
