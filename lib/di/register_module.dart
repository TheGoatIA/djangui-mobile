import 'package:chopper/chopper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

import '../core/network/api_client.dart';
import '../core/database/database.dart';
import '../features/auth/data/datasources/auth_api_service.dart';
import '../features/transactions/data/datasources/transaction_api_service.dart';
import '../features/budgets/data/datasources/budget_api_service.dart';
import '../features/goals/data/datasources/goal_api_service.dart';
import '../features/challenges/data/datasources/challenge_api_service.dart';
import '../features/coach/data/datasources/coach_api_service.dart';
import '../features/insights/data/datasources/insight_api_service.dart';
import '../features/insights/data/datasources/ai_api_service.dart';
import '../features/investments/data/datasources/investment_api_service.dart';
import '../features/subscription/data/datasources/payment_api_service.dart';
import '../features/reports/data/datasources/reports_api_service.dart';
import '../features/system/data/datasources/system_api_service.dart';
import '../features/notifications/data/datasources/notification_api_service.dart';
import '../features/upload/data/datasources/upload_api_service.dart';
import '../features/support/data/datasources/support_api_service.dart';
import '../features/voice/data/datasources/voice_api_service.dart';
import '../features/tontine/data/datasources/tontine_api_service.dart';
import '../features/user_subscriptions/data/datasources/subscription_api_service.dart';
import 'package:kauri/features/analytics/data/datasources/analytics_api_service.dart';
import 'injection.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @lazySingleton
  ChopperClient get chopperClient => KauriApiClient.create();

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  AuthApiService get authApiService =>
      AuthApiService.create(getIt<ChopperClient>());

  @lazySingleton
  TransactionApiService get transactionApiService =>
      TransactionApiService.create(getIt<ChopperClient>());

  @lazySingleton
  BudgetApiService get budgetApiService =>
      BudgetApiService.create(getIt<ChopperClient>());

  @lazySingleton
  GoalApiService get goalApiService =>
      GoalApiService.create(getIt<ChopperClient>());

  @lazySingleton
  ChallengeApiService get challengeApiService =>
      ChallengeApiService.create(getIt<ChopperClient>());

  @lazySingleton
  CoachApiService get coachApiService =>
      CoachApiService.create(getIt<ChopperClient>());

  @lazySingleton
  InsightApiService get insightApiService =>
      InsightApiService.create(getIt<ChopperClient>());

  @lazySingleton
  AiApiService get aiApiService => AiApiService.create(getIt<ChopperClient>());

  @lazySingleton
  InvestmentApiService get investmentApiService =>
      InvestmentApiService.create(getIt<ChopperClient>());

  @lazySingleton
  PaymentApiService get paymentApiService =>
      PaymentApiService.create(getIt<ChopperClient>());

  @lazySingleton
  ReportsApiService get reportsApiService =>
      ReportsApiService.create(getIt<ChopperClient>());

  @lazySingleton
  SystemApiService get systemApiService =>
      SystemApiService.create(getIt<ChopperClient>());

  @lazySingleton
  NotificationApiService get notificationApiService =>
      NotificationApiService.create(getIt<ChopperClient>());

  @lazySingleton
  UploadApiService get uploadApiService =>
      UploadApiService.create(getIt<ChopperClient>());

  @lazySingleton
  SupportApiService get supportApiService =>
      SupportApiService.create(getIt<ChopperClient>());

  @lazySingleton
  VoiceApiService get voiceApiService =>
      VoiceApiService.create(getIt<ChopperClient>());

  @lazySingleton
  TontineApiService get tontineApiService =>
      TontineApiService.create(getIt<ChopperClient>());

  @lazySingleton
  SubscriptionApiService get subscriptionApiService =>
      SubscriptionApiService.create(getIt<ChopperClient>());

  @lazySingleton
  AnalyticsApiService get analyticsApiService =>
      AnalyticsApiService.create(getIt<ChopperClient>());

  @lazySingleton
  AppDatabase get database => AppDatabase();

  @lazySingleton
  Logger get logger => Logger();
}
