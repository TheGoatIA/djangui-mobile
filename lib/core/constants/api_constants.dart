class ApiConstants {
  // baseUrl should be retrieved from dotenv.env['API_BASE_URL'] in the NetworkModule

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String firebaseAuth = '/auth/firebase';
  static const String linkPhone = '/auth/link-phone';
  static const String fcmToken = '/auth/fcm-token';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';
  static const String me = '/auth/me';
  static const String changePassword = '/auth/change-password';
  static const String deleteMe = '/auth/delete-me';
  static const String sessions = '/auth/sessions';

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
}
