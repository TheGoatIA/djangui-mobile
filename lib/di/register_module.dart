import 'package:chopper/chopper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:kauri/core/config/env_config.dart';
import 'package:kauri/core/network/api_client.dart';
import 'package:kauri/core/database/database.dart';
import 'package:kauri/features/auth/data/datasources/auth_api_service.dart';
import 'package:kauri/features/transactions/data/datasources/transaction_api_service.dart';
import 'package:kauri/features/budgets/data/datasources/budget_api_service.dart';
import 'package:kauri/features/goals/data/datasources/goal_api_service.dart';
import 'package:kauri/features/challenges/data/datasources/challenge_api_service.dart';
import 'package:kauri/features/coach/data/datasources/coach_api_service.dart';
import 'package:kauri/features/insights/data/datasources/insight_api_service.dart';
import 'package:kauri/features/insights/data/datasources/ai_api_service.dart';
import 'package:kauri/features/investments/data/datasources/investment_api_service.dart';
import 'package:kauri/features/subscription/data/datasources/payment_api_service.dart';
import 'package:kauri/features/reports/data/datasources/reports_api_service.dart';
import 'package:kauri/features/system/data/datasources/system_api_service.dart';
import 'package:kauri/features/system/data/datasources/config_api_service.dart';
import 'package:kauri/features/notifications/data/datasources/notification_api_service.dart';
import 'package:kauri/features/upload/data/datasources/upload_api_service.dart';
import 'package:kauri/features/support/data/datasources/support_api_service.dart';
import 'package:kauri/features/voice/data/datasources/voice_api_service.dart';
import 'package:kauri/features/tontine/data/datasources/tontine_api_service.dart';
import 'package:kauri/features/user_subscriptions/data/datasources/subscription_api_service.dart';
import 'package:kauri/features/analytics/data/datasources/analytics_api_service.dart';
import 'package:kauri/features/payments/data/datasources/fintech_api_service.dart';
import 'package:kauri/features/payments/data/datasources/payments_api_service.dart';
import 'package:kauri/di/injection.dart';

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
  ForecastApiService get forecastApiService =>
      ForecastApiService.create(getIt<ChopperClient>());

  @lazySingleton
  SystemApiService get systemApiService =>
      SystemApiService.create(getIt<ChopperClient>());

  @lazySingleton
  ConfigApiService get configApiService =>
      ConfigApiService.create(getIt<ChopperClient>());

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
  FintechApiService get fintechApiService =>
      FintechApiService.create(getIt<ChopperClient>());

  @lazySingleton
  PaymentsApiService get paymentsApiService =>
      PaymentsApiService.create(getIt<ChopperClient>());

  @lazySingleton
  AppDatabase get database => AppDatabase();

  @lazySingleton
  Logger get logger => Logger();

  // Par défaut, ce package vérifie 3 API démo tierces au hasard
  // (dummyapi.online, jsonplaceholder.typicode.com, fakestoreapi.com) —
  // aucun rapport avec Kauri, et donc aucune garantie de rester en ligne ni
  // de refléter si NOTRE serveur est joignable. C'est ce qui causait des
  // faux "hors-ligne" juste après un appel réseau pourtant réussi (ex: un
  // budget créé avec succès, puis rechargé depuis un cache local obsolète
  // car isConnected répondait `false`) : ce qui compte pour cette app n'est
  // pas "internet existe quelque part" mais "l'API Kauri est joignable". On
  // vérifie donc directement son propre endpoint de santé public.
  @lazySingleton
  InternetConnectionChecker get connectionChecker =>
      InternetConnectionChecker.createInstance(
        addresses: [
          AddressCheckOption(
            uri: Uri.parse(
              '${EnvConfig.apiBaseUrl.replaceAll('/api/v1', '')}/api/health',
            ),
          ),
        ],
      );
}
