class ApiConstants {
  // baseUrl should be retrieved from dotenv.env['API_BASE_URL'] in the NetworkModule

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String googleAuth = '/auth/google';
  static const String fcmToken = '/auth/fcm-token';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';

  // Transactions
  static const String transactions = '/transactions';

  // Budgets
  static const String budgets = '/budgets';

  // Goals
  static const String goals = '/goals';

  // AI & Automation
  static const String ocrScan = '/ocr/scan';
  static const String smsParse = '/sms/parse';
  static const String reportNarrative = '/reports/narrative';

  // Investments
  static const String investments = '/investments';

  // Payments
  static const String notchPayInit = '/payments/init/notchpay';
  static const String stripeCheckout = '/payments/checkout/stripe';
}
