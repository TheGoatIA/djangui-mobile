// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:chopper/chopper.dart' as _i31;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i973;
import 'package:kauri/core/database/database.dart' as _i777;
import 'package:kauri/core/network/network_info.dart' as _i935;
import 'package:kauri/core/services/app_icon_service.dart' as _i40;
import 'package:kauri/core/services/log_service.dart' as _i169;
import 'package:kauri/core/services/notification_service.dart' as _i273;
import 'package:kauri/core/services/ocr_service.dart' as _i950;
import 'package:kauri/core/services/payment_service.dart' as _i342;
import 'package:kauri/core/services/share_service.dart' as _i639;
import 'package:kauri/core/services/success_animation_service.dart' as _i3;
import 'package:kauri/core/services/sync_service.dart' as _i75;
import 'package:kauri/core/services/telemetry_service.dart' as _i892;
import 'package:kauri/core/services/tutorial_service.dart' as _i899;
import 'package:kauri/di/register_module.dart' as _i617;
import 'package:kauri/features/analytics/data/datasources/analytics_api_service.dart'
    as _i769;
import 'package:kauri/features/analytics/data/repositories/analytics_repository_impl.dart'
    as _i859;
import 'package:kauri/features/analytics/domain/repositories/analytics_repository.dart'
    as _i924;
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart'
    as _i1035;
import 'package:kauri/features/auth/data/datasources/auth_api_service.dart'
    as _i974;
import 'package:kauri/features/auth/data/datasources/auth_local_datasource.dart'
    as _i240;
import 'package:kauri/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i777;
import 'package:kauri/features/auth/data/repositories/auth_repository_impl.dart'
    as _i541;
import 'package:kauri/features/auth/domain/repositories/auth_repository.dart'
    as _i344;
import 'package:kauri/features/auth/presentation/bloc/auth_bloc.dart' as _i714;
import 'package:kauri/features/budgets/data/datasources/budget_api_service.dart'
    as _i91;
import 'package:kauri/features/budgets/data/datasources/budget_local_datasource.dart'
    as _i302;
import 'package:kauri/features/budgets/data/datasources/budget_remote_datasource.dart'
    as _i831;
import 'package:kauri/features/budgets/data/repositories/budget_repository_impl.dart'
    as _i136;
import 'package:kauri/features/budgets/domain/repositories/budget_repository.dart'
    as _i116;
import 'package:kauri/features/budgets/presentation/bloc/budgets_bloc.dart'
    as _i434;
import 'package:kauri/features/challenges/data/datasources/challenge_api_service.dart'
    as _i84;
import 'package:kauri/features/challenges/data/datasources/challenge_local_datasource.dart'
    as _i895;
import 'package:kauri/features/challenges/data/datasources/challenge_remote_datasource.dart'
    as _i836;
import 'package:kauri/features/challenges/data/repositories/challenge_repository_impl.dart'
    as _i380;
import 'package:kauri/features/challenges/domain/repositories/challenge_repository.dart'
    as _i375;
import 'package:kauri/features/challenges/presentation/bloc/challenges_bloc.dart'
    as _i506;
import 'package:kauri/features/coach/data/datasources/coach_api_service.dart'
    as _i621;
import 'package:kauri/features/coach/data/datasources/coach_local_datasource.dart'
    as _i580;
import 'package:kauri/features/coach/data/datasources/coach_remote_datasource.dart'
    as _i617;
import 'package:kauri/features/coach/data/repositories/coach_repository_impl.dart'
    as _i307;
import 'package:kauri/features/coach/domain/repositories/coach_repository.dart'
    as _i160;
import 'package:kauri/features/coach/presentation/bloc/coach_bloc.dart'
    as _i405;
import 'package:kauri/features/dashboard/presentation/bloc/dashboard_bloc.dart'
    as _i570;
import 'package:kauri/features/goals/data/datasources/goal_api_service.dart'
    as _i425;
import 'package:kauri/features/goals/data/datasources/goal_local_datasource.dart'
    as _i612;
import 'package:kauri/features/goals/data/datasources/goal_remote_datasource.dart'
    as _i362;
import 'package:kauri/features/goals/data/repositories/goal_repository_impl.dart'
    as _i457;
import 'package:kauri/features/goals/domain/repositories/goal_repository.dart'
    as _i751;
import 'package:kauri/features/goals/presentation/bloc/goals_bloc.dart'
    as _i946;
import 'package:kauri/features/insights/data/datasources/ai_api_service.dart'
    as _i595;
import 'package:kauri/features/insights/data/datasources/ai_remote_datasource.dart'
    as _i62;
import 'package:kauri/features/insights/data/datasources/insight_api_service.dart'
    as _i830;
import 'package:kauri/features/insights/data/repositories/insight_repository_impl.dart'
    as _i923;
import 'package:kauri/features/insights/domain/repositories/insight_repository.dart'
    as _i448;
import 'package:kauri/features/insights/presentation/bloc/insights_bloc.dart'
    as _i717;
import 'package:kauri/features/investments/data/datasources/investment_api_service.dart'
    as _i565;
import 'package:kauri/features/investments/data/repositories/investment_repository_impl.dart'
    as _i571;
import 'package:kauri/features/investments/domain/repositories/investment_repository.dart'
    as _i71;
import 'package:kauri/features/investments/presentation/bloc/investments_bloc.dart'
    as _i686;
import 'package:kauri/features/notifications/data/datasources/notification_api_service.dart'
    as _i921;
import 'package:kauri/features/notifications/data/datasources/notification_remote_datasource.dart'
    as _i356;
import 'package:kauri/features/notifications/data/datasources/notification_remote_datasource_impl.dart'
    as _i756;
import 'package:kauri/features/notifications/data/repositories/notification_repository_impl.dart'
    as _i747;
import 'package:kauri/features/notifications/domain/repositories/notification_repository.dart'
    as _i224;
import 'package:kauri/features/notifications/presentation/bloc/notifications_bloc.dart'
    as _i786;
import 'package:kauri/features/payments/data/datasources/fintech_api_service.dart'
    as _i904;
import 'package:kauri/features/payments/data/datasources/payments_api_service.dart'
    as _i724;
import 'package:kauri/features/payments/data/repositories/fintech_repository_impl.dart'
    as _i128;
import 'package:kauri/features/payments/data/repositories/payment_repository_impl.dart'
    as _i535;
import 'package:kauri/features/payments/domain/repositories/fintech_repository.dart'
    as _i958;
import 'package:kauri/features/payments/domain/repositories/payment_repository.dart'
    as _i593;
import 'package:kauri/features/payments/presentation/bloc/fintech_bloc.dart'
    as _i697;
import 'package:kauri/features/payments/presentation/bloc/payment_bloc.dart'
    as _i725;
import 'package:kauri/features/premium/data/datasources/premium_api_service.dart'
    as _i520;
import 'package:kauri/features/premium/data/repositories/premium_repository_impl.dart'
    as _i702;
import 'package:kauri/features/premium/domain/repositories/premium_repository.dart'
    as _i283;
import 'package:kauri/features/premium/presentation/bloc/premium_bloc.dart'
    as _i325;
import 'package:kauri/features/reports/data/datasources/reports_api_service.dart'
    as _i158;
import 'package:kauri/features/reports/data/datasources/reports_local_datasource.dart'
    as _i515;
import 'package:kauri/features/reports/data/repositories/reports_repository_impl.dart'
    as _i423;
import 'package:kauri/features/reports/domain/repositories/reports_repository.dart'
    as _i760;
import 'package:kauri/features/settings/presentation/bloc/settings_bloc.dart'
    as _i53;
import 'package:kauri/features/subscription/data/datasources/payment_api_service.dart'
    as _i1020;
import 'package:kauri/features/support/data/datasources/support_api_service.dart'
    as _i677;
import 'package:kauri/features/support/data/repositories/support_repository_impl.dart'
    as _i427;
import 'package:kauri/features/support/domain/repositories/support_repository.dart'
    as _i810;
import 'package:kauri/features/support/presentation/bloc/support_bloc.dart'
    as _i111;
import 'package:kauri/features/system/data/datasources/config_api_service.dart'
    as _i92;
import 'package:kauri/features/system/data/datasources/system_api_service.dart'
    as _i33;
import 'package:kauri/features/system/data/repositories/system_repository_impl.dart'
    as _i143;
import 'package:kauri/features/system/domain/repositories/system_repository.dart'
    as _i608;
import 'package:kauri/features/system/presentation/bloc/system_bloc.dart'
    as _i376;
import 'package:kauri/features/tontine/data/datasources/tontine_api_service.dart'
    as _i534;
import 'package:kauri/features/tontine/data/datasources/tontine_local_datasource.dart'
    as _i430;
import 'package:kauri/features/tontine/data/repositories/tontine_repository_impl.dart'
    as _i699;
import 'package:kauri/features/tontine/domain/repositories/tontine_repository.dart'
    as _i996;
import 'package:kauri/features/tontine/presentation/bloc/tontine_bloc.dart'
    as _i96;
import 'package:kauri/features/transactions/data/datasources/transaction_api_service.dart'
    as _i982;
import 'package:kauri/features/transactions/data/datasources/transaction_local_datasource.dart'
    as _i680;
import 'package:kauri/features/transactions/data/datasources/transaction_remote_datasource.dart'
    as _i534;
import 'package:kauri/features/transactions/data/repositories/transaction_repository_impl.dart'
    as _i296;
import 'package:kauri/features/transactions/domain/repositories/transaction_repository.dart'
    as _i245;
import 'package:kauri/features/transactions/presentation/bloc/transactions_bloc.dart'
    as _i714;
import 'package:kauri/features/upload/data/datasources/upload_api_service.dart'
    as _i242;
import 'package:kauri/features/upload/data/datasources/upload_remote_datasource.dart'
    as _i991;
import 'package:kauri/features/upload/data/repositories/upload_repository_impl.dart'
    as _i1003;
import 'package:kauri/features/upload/domain/repositories/upload_repository.dart'
    as _i105;
import 'package:kauri/features/user_subscriptions/data/datasources/subscription_api_service.dart'
    as _i181;
import 'package:kauri/features/user_subscriptions/data/datasources/subscription_local_datasource.dart'
    as _i578;
import 'package:kauri/features/user_subscriptions/data/repositories/subscription_repository_impl.dart'
    as _i696;
import 'package:kauri/features/user_subscriptions/domain/repositories/subscription_repository.dart'
    as _i105;
import 'package:kauri/features/user_subscriptions/presentation/bloc/subscription_bloc.dart'
    as _i673;
import 'package:kauri/features/voice/data/datasources/voice_api_service.dart'
    as _i195;
import 'package:kauri/features/voice/data/repositories/voice_repository_impl.dart'
    as _i271;
import 'package:kauri/features/voice/domain/repositories/voice_repository.dart'
    as _i1033;
import 'package:kauri/features/voice/presentation/bloc/voice_bloc.dart'
    as _i415;
import 'package:logger/logger.dart' as _i974;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i892.TelemetryService>(() => _i892.TelemetryService());
    gh.lazySingleton<_i40.AppIconService>(() => _i40.AppIconService());
    gh.lazySingleton<_i169.LogService>(() => _i169.LogService());
    gh.lazySingleton<_i273.NotificationService>(
      () => _i273.NotificationService(),
    );
    gh.lazySingleton<_i950.OCRService>(() => _i950.OCRService());
    gh.lazySingleton<_i639.ShareService>(() => _i639.ShareService());
    gh.lazySingleton<_i3.SuccessAnimationService>(
      () => _i3.SuccessAnimationService(),
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i31.ChopperClient>(() => registerModule.chopperClient);
    gh.lazySingleton<_i974.AuthApiService>(() => registerModule.authApiService);
    gh.lazySingleton<_i982.TransactionApiService>(
      () => registerModule.transactionApiService,
    );
    gh.lazySingleton<_i91.BudgetApiService>(
      () => registerModule.budgetApiService,
    );
    gh.lazySingleton<_i425.GoalApiService>(() => registerModule.goalApiService);
    gh.lazySingleton<_i84.ChallengeApiService>(
      () => registerModule.challengeApiService,
    );
    gh.lazySingleton<_i621.CoachApiService>(
      () => registerModule.coachApiService,
    );
    gh.lazySingleton<_i830.InsightApiService>(
      () => registerModule.insightApiService,
    );
    gh.lazySingleton<_i595.AiApiService>(() => registerModule.aiApiService);
    gh.lazySingleton<_i565.InvestmentApiService>(
      () => registerModule.investmentApiService,
    );
    gh.lazySingleton<_i1020.PaymentApiService>(
      () => registerModule.paymentApiService,
    );
    gh.lazySingleton<_i158.ReportsApiService>(
      () => registerModule.reportsApiService,
    );
    gh.lazySingleton<_i158.ForecastApiService>(
      () => registerModule.forecastApiService,
    );
    gh.lazySingleton<_i33.SystemApiService>(
      () => registerModule.systemApiService,
    );
    gh.lazySingleton<_i92.ConfigApiService>(
      () => registerModule.configApiService,
    );
    gh.lazySingleton<_i921.NotificationApiService>(
      () => registerModule.notificationApiService,
    );
    gh.lazySingleton<_i242.UploadApiService>(
      () => registerModule.uploadApiService,
    );
    gh.lazySingleton<_i677.SupportApiService>(
      () => registerModule.supportApiService,
    );
    gh.lazySingleton<_i195.VoiceApiService>(
      () => registerModule.voiceApiService,
    );
    gh.lazySingleton<_i534.TontineApiService>(
      () => registerModule.tontineApiService,
    );
    gh.lazySingleton<_i181.SubscriptionApiService>(
      () => registerModule.subscriptionApiService,
    );
    gh.lazySingleton<_i769.AnalyticsApiService>(
      () => registerModule.analyticsApiService,
    );
    gh.lazySingleton<_i904.FintechApiService>(
      () => registerModule.fintechApiService,
    );
    gh.lazySingleton<_i724.PaymentsApiService>(
      () => registerModule.paymentsApiService,
    );
    gh.lazySingleton<_i777.AppDatabase>(() => registerModule.database);
    gh.lazySingleton<_i974.Logger>(() => registerModule.logger);
    gh.lazySingleton<_i973.InternetConnectionChecker>(
      () => registerModule.connectionChecker,
    );
    gh.lazySingleton<_i617.CoachRemoteDataSource>(
      () => _i617.CoachRemoteDataSourceImpl(gh<_i621.CoachApiService>()),
    );
    gh.lazySingleton<_i356.NotificationRemoteDataSource>(
      () => _i756.NotificationRemoteDataSourceImpl(
        gh<_i921.NotificationApiService>(),
      ),
    );
    gh.lazySingleton<_i991.UploadRemoteDataSource>(
      () => _i991.UploadRemoteDataSourceImpl(gh<_i242.UploadApiService>()),
    );
    gh.lazySingleton<_i302.BudgetLocalDataSource>(
      () => _i302.BudgetLocalDataSourceImpl(gh<_i777.AppDatabase>()),
    );
    gh.lazySingleton<_i430.TontineLocalDataSource>(
      () => _i430.TontineLocalDataSourceImpl(gh<_i777.AppDatabase>()),
    );
    gh.lazySingleton<_i578.SubscriptionLocalDataSource>(
      () => _i578.SubscriptionLocalDataSourceImpl(gh<_i777.AppDatabase>()),
    );
    gh.lazySingleton<_i680.TransactionLocalDataSource>(
      () => _i680.TransactionLocalDataSourceImpl(gh<_i777.AppDatabase>()),
    );
    gh.lazySingleton<_i515.ReportsLocalDataSource>(
      () => _i515.ReportsLocalDataSourceImpl(gh<_i777.AppDatabase>()),
    );
    gh.lazySingleton<_i895.ChallengeLocalDataSource>(
      () => _i895.ChallengeLocalDataSourceImpl(gh<_i777.AppDatabase>()),
    );
    gh.lazySingleton<_i580.CoachLocalDataSource>(
      () => _i580.CoachLocalDataSourceImpl(gh<_i777.AppDatabase>()),
    );
    gh.lazySingleton<_i608.SystemRepository>(
      () => _i143.SystemRepositoryImpl(
        gh<_i33.SystemApiService>(),
        gh<_i92.ConfigApiService>(),
      ),
    );
    gh.lazySingleton<_i240.AuthLocalDataSource>(
      () => _i240.AuthLocalDataSourceImpl(
        gh<_i558.FlutterSecureStorage>(),
        gh<_i777.AppDatabase>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.lazySingleton<_i612.GoalLocalDataSource>(
      () => _i612.GoalLocalDataSourceImpl(gh<_i777.AppDatabase>()),
    );
    gh.lazySingleton<_i831.BudgetRemoteDataSource>(
      () => _i831.BudgetRemoteDataSourceImpl(gh<_i91.BudgetApiService>()),
    );
    gh.lazySingleton<_i62.AIRemoteDataSource>(
      () => _i62.AIRemoteDataSource(gh<_i595.AiApiService>()),
    );
    gh.lazySingleton<_i899.TutorialService>(
      () => _i899.TutorialService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i283.PremiumRepository>(
      () => _i702.PremiumRepositoryImpl(gh<_i520.PremiumApiService>()),
    );
    gh.lazySingleton<_i935.NetworkInfo>(
      () => _i935.NetworkInfoImpl(gh<_i973.InternetConnectionChecker>()),
    );
    gh.lazySingleton<_i958.FintechRepository>(
      () => _i128.FintechRepositoryImpl(
        gh<_i904.FintechApiService>(),
        gh<_i935.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i362.GoalRemoteDataSource>(
      () => _i362.GoalRemoteDataSourceImpl(gh<_i425.GoalApiService>()),
    );
    gh.lazySingleton<_i593.PaymentRepository>(
      () => _i535.PaymentRepositoryImpl(
        gh<_i724.PaymentsApiService>(),
        gh<_i935.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i534.TransactionRemoteDataSource>(
      () => _i534.TransactionRemoteDataSourceImpl(
        gh<_i982.TransactionApiService>(),
      ),
    );
    gh.lazySingleton<_i160.CoachRepository>(
      () => _i307.CoachRepositoryImpl(
        gh<_i617.CoachRemoteDataSource>(),
        gh<_i580.CoachLocalDataSource>(),
        gh<_i935.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i1033.VoiceRepository>(
      () => _i271.VoiceRepositoryImpl(
        gh<_i195.VoiceApiService>(),
        gh<_i935.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i342.PaymentService>(
      () => _i342.PaymentService(gh<_i1020.PaymentApiService>()),
    );
    gh.factory<_i376.SystemBloc>(
      () => _i376.SystemBloc(gh<_i608.SystemRepository>()),
    );
    gh.lazySingleton<_i996.TontineRepository>(
      () => _i699.TontineRepositoryImpl(
        gh<_i534.TontineApiService>(),
        gh<_i430.TontineLocalDataSource>(),
        gh<_i935.NetworkInfo>(),
        gh<_i777.AppDatabase>(),
      ),
    );
    gh.lazySingleton<_i836.ChallengeRemoteDataSource>(
      () => _i836.ChallengeRemoteDataSourceImpl(gh<_i84.ChallengeApiService>()),
    );
    gh.lazySingleton<_i777.AuthRemoteDataSource>(
      () => _i777.AuthRemoteDataSourceImpl(
        gh<_i974.AuthApiService>(),
        gh<_i240.AuthLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i71.InvestmentRepository>(
      () => _i571.InvestmentRepositoryImpl(
        gh<_i777.AppDatabase>(),
        gh<_i565.InvestmentApiService>(),
      ),
    );
    gh.factory<_i725.PaymentBloc>(
      () => _i725.PaymentBloc(gh<_i593.PaymentRepository>()),
    );
    gh.lazySingleton<_i116.BudgetRepository>(
      () => _i136.BudgetRepositoryImpl(
        gh<_i831.BudgetRemoteDataSource>(),
        gh<_i302.BudgetLocalDataSource>(),
        gh<_i935.NetworkInfo>(),
        gh<_i777.AppDatabase>(),
      ),
    );
    gh.lazySingleton<_i751.GoalRepository>(
      () => _i457.GoalRepositoryImpl(
        gh<_i362.GoalRemoteDataSource>(),
        gh<_i612.GoalLocalDataSource>(),
        gh<_i935.NetworkInfo>(),
        gh<_i777.AppDatabase>(),
      ),
    );
    gh.lazySingleton<_i697.FintechBloc>(
      () => _i697.FintechBloc(gh<_i958.FintechRepository>()),
    );
    gh.lazySingleton<_i224.NotificationRepository>(
      () => _i747.NotificationRepositoryImpl(
        gh<_i356.NotificationRemoteDataSource>(),
        gh<_i935.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i105.UploadRepository>(
      () => _i1003.UploadRepositoryImpl(
        gh<_i991.UploadRemoteDataSource>(),
        gh<_i935.NetworkInfo>(),
      ),
    );
    gh.factory<_i686.InvestmentsBloc>(
      () => _i686.InvestmentsBloc(gh<_i71.InvestmentRepository>()),
    );
    gh.lazySingleton<_i105.SubscriptionRepository>(
      () => _i696.SubscriptionRepositoryImpl(
        gh<_i181.SubscriptionApiService>(),
        gh<_i578.SubscriptionLocalDataSource>(),
        gh<_i935.NetworkInfo>(),
        gh<_i777.AppDatabase>(),
      ),
    );
    gh.lazySingleton<_i245.TransactionRepository>(
      () => _i296.TransactionRepositoryImpl(
        gh<_i534.TransactionRemoteDataSource>(),
        gh<_i680.TransactionLocalDataSource>(),
        gh<_i935.NetworkInfo>(),
        gh<_i777.AppDatabase>(),
      ),
    );
    gh.lazySingleton<_i810.SupportRepository>(
      () => _i427.SupportRepositoryImpl(
        gh<_i677.SupportApiService>(),
        gh<_i935.NetworkInfo>(),
      ),
    );
    gh.factory<_i786.NotificationsBloc>(
      () => _i786.NotificationsBloc(gh<_i224.NotificationRepository>()),
    );
    gh.lazySingleton<_i344.AuthRepository>(
      () => _i541.AuthRepositoryImpl(
        gh<_i777.AuthRemoteDataSource>(),
        gh<_i240.AuthLocalDataSource>(),
        gh<_i935.NetworkInfo>(),
      ),
    );
    gh.factory<_i434.BudgetsBloc>(
      () => _i434.BudgetsBloc(gh<_i116.BudgetRepository>()),
    );
    gh.lazySingleton<_i924.AnalyticsRepository>(
      () => _i859.AnalyticsRepositoryImpl(
        gh<_i769.AnalyticsApiService>(),
        gh<_i935.NetworkInfo>(),
      ),
    );
    gh.factory<_i405.CoachBloc>(
      () => _i405.CoachBloc(gh<_i160.CoachRepository>()),
    );
    gh.lazySingleton<_i714.AuthBloc>(
      () => _i714.AuthBloc(
        gh<_i344.AuthRepository>(),
        gh<_i105.UploadRepository>(),
      ),
    );
    gh.lazySingleton<_i448.InsightRepository>(
      () => _i923.InsightRepositoryImpl(
        gh<_i830.InsightApiService>(),
        gh<_i935.NetworkInfo>(),
      ),
    );
    gh.factory<_i325.PremiumBloc>(
      () => _i325.PremiumBloc(gh<_i283.PremiumRepository>()),
    );
    gh.factory<_i415.VoiceBloc>(
      () => _i415.VoiceBloc(gh<_i1033.VoiceRepository>()),
    );
    gh.factory<_i946.GoalsBloc>(
      () => _i946.GoalsBloc(gh<_i751.GoalRepository>()),
    );
    gh.lazySingleton<_i760.ReportsRepository>(
      () => _i423.ReportsRepositoryImpl(
        gh<_i158.ReportsApiService>(),
        gh<_i158.ForecastApiService>(),
        gh<_i935.NetworkInfo>(),
        gh<_i515.ReportsLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i375.ChallengeRepository>(
      () => _i380.ChallengeRepositoryImpl(
        gh<_i836.ChallengeRemoteDataSource>(),
        gh<_i895.ChallengeLocalDataSource>(),
        gh<_i935.NetworkInfo>(),
        gh<_i777.AppDatabase>(),
      ),
    );
    gh.factory<_i96.TontineBloc>(
      () => _i96.TontineBloc(gh<_i996.TontineRepository>()),
    );
    gh.lazySingleton<_i1035.AnalyticsManager>(
      () => _i1035.AnalyticsManager(
        gh<_i924.AnalyticsRepository>(),
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.lazySingleton<_i714.TransactionsBloc>(
      () => _i714.TransactionsBloc(gh<_i245.TransactionRepository>()),
    );
    gh.factory<_i570.DashboardBloc>(
      () => _i570.DashboardBloc(gh<_i760.ReportsRepository>()),
    );
    gh.factory<_i717.InsightsBloc>(
      () => _i717.InsightsBloc(gh<_i760.ReportsRepository>()),
    );
    gh.factory<_i111.SupportBloc>(
      () => _i111.SupportBloc(gh<_i810.SupportRepository>()),
    );
    gh.lazySingleton<_i75.SyncService>(
      () => _i75.SyncService(
        gh<_i777.AppDatabase>(),
        gh<_i534.TransactionRemoteDataSource>(),
        gh<_i181.SubscriptionApiService>(),
        gh<_i362.GoalRemoteDataSource>(),
        gh<_i836.ChallengeRemoteDataSource>(),
        gh<_i831.BudgetRemoteDataSource>(),
        gh<_i534.TontineApiService>(),
        gh<_i344.AuthRepository>(),
        gh<_i974.Logger>(),
        gh<_i973.InternetConnectionChecker>(),
      ),
    );
    gh.factory<_i53.SettingsBloc>(
      () => _i53.SettingsBloc(
        gh<_i460.SharedPreferences>(),
        gh<_i344.AuthRepository>(),
      ),
    );
    gh.factory<_i673.SubscriptionBloc>(
      () => _i673.SubscriptionBloc(gh<_i105.SubscriptionRepository>()),
    );
    gh.factory<_i506.ChallengesBloc>(
      () => _i506.ChallengesBloc(gh<_i375.ChallengeRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i617.RegisterModule {}
