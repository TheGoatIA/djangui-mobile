class ApiConstants {
  static const String baseUrl = 'http://localhost:3000/api';
  static const String apiVersion = '/v1';

  // Auth
  static const String login = '$apiVersion/auth/login';
  static const String register = '$apiVersion/auth/register';
  static const String refresh = '$apiVersion/auth/refresh';
  static const String logout = '$apiVersion/auth/logout';
  static const String googleAuth = '$apiVersion/auth/google';
  static const String fcmToken = '$apiVersion/auth/fcm-token';

  // Transactions
  static const String transactions = '$apiVersion/transactions';

  // Budgets
  static const String budgets = '$apiVersion/budgets';

  // Goals
  static const String goals = '$apiVersion/goals';

  // AI & Automation
  static const String ocrScan = '$apiVersion/ocr/scan';
  static const String smsParse = '$apiVersion/sms/parse';
  static const String reportNarrative = '$apiVersion/reports/narrative';

  // Investments
  static const String investments = '$apiVersion/investments';

  // Payments
  static const String notchPayInit = '$apiVersion/payments/init/notchpay';
  static const String stripeCheckout = '$apiVersion/payments/checkout/stripe';
}
