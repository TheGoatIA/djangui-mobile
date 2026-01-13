class ApiConstants {
  // baseUrl should be retrieved from dotenv.env['API_BASE_URL'] in the NetworkModule

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String firebaseAuth = '/auth/firebase';
  static const String appleAuth = '/auth/apple';
  static const String linkPhone = '/auth/link-phone';
  static const String fcmToken = '/auth/fcm-token';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';
  static const String me = '/auth/me';
  static const String changePassword = '/auth/change-password';
  static const String deleteMe = '/auth/delete-me';
  static const String sessions = '/auth/sessions';
  static const String connection = '/auth/connection';
  static const String requestCountryChange = '/auth/request-country-change';

  // Transactions
  static const String transactions = '/transactions';
  static const String transactionsBulk = '/transactions/bulk';

  // Budgets
  static const String budgets = '/budgets';
  static const String budgetsCurrent = '/budgets/current';

  // Goals
  static const String goals = '/goals';

  // AI & Automation
  static const String ocrScan = '/ocr/scan';
  static const String smsParse = '/sms/parse';
  static const String smsBulkParse = '/sms/bulk-parse';
  static const String voiceProcess = '/voice/process';

  // Reports
  static const String reportDashboard = '/reports/dashboard';
  static const String reportAnalysis = '/reports/analysis';
  static const String reportNarrative = '/reports/narrative';

  // Investments
  static const String investments = '/investments';

  // Challenges
  static const String challenges = '/challenges';
  static const String myChallenges = '/challenges/my-challenges';
  static const String validateWeek = '/challenges/validate-week';

  // Upload
  static const String uploadReceipt = '/upload/receipt';
  static const String uploadAvatar = '/upload/avatar';

  // Payments
  static const String notchPayInit = '/payments/init/notchpay';
  static const String stripeCheckout = '/payments/checkout/stripe';
  static const String verifyPayment = '/payments/verify/{reference}';
  static const String paymentHistory = '/payments';
  static const String cancelSubscription = '/payments/cancel-subscription';

  // Notifications
  static const String notifications = '/notifications';
  static const String notificationsMarkRead = '/notifications/mark-all-read';
  static const String notificationsUnreadCount = '/notifications/unread-count';

  // Support
  static const String supportTickets = '/support/tickets';

  // Tontines
  static const String tontines = '/tontines';
  static const String tontinesJoin = '/tontines/join';
  static const String tontinesContribute = '/tontines/contribute';
  static const String tontineContributions = '/tontines/{id}/contributions';
  static const String validateContribution =
      '/tontines/contributions/{id}/validate';

  // System
  static const String publicSettings = '/system/public-settings';

  // Subscriptions (Recurring Expenses)
  static const String subscriptions = '/subscriptions';
  static const String subscriptionsDetect = '/subscriptions/detect';
}
