// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:chopper/chopper.dart' as _i31;
import 'package:djangui/core/database/database.dart' as _i730;
import 'package:djangui/core/network/network_info.dart' as _i574;
import 'package:djangui/core/services/notification_service.dart' as _i275;
import 'package:djangui/core/services/ocr_service.dart' as _i282;
import 'package:djangui/core/services/payment_service.dart' as _i29;
import 'package:djangui/core/services/share_service.dart' as _i69;
import 'package:djangui/core/services/sms_service.dart' as _i252;
import 'package:djangui/core/services/sync_service.dart' as _i316;
import 'package:djangui/di/register_module.dart' as _i153;
import 'package:djangui/features/auth/data/datasources/auth_api_service.dart'
    as _i651;
import 'package:djangui/features/auth/data/datasources/auth_local_datasource.dart'
    as _i520;
import 'package:djangui/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i1046;
import 'package:djangui/features/auth/data/repositories/auth_repository_impl.dart'
    as _i29;
import 'package:djangui/features/auth/domain/repositories/auth_repository.dart'
    as _i1012;
import 'package:djangui/features/auth/presentation/bloc/auth_bloc.dart' as _i48;
import 'package:djangui/features/budgets/data/datasources/budget_api_service.dart'
    as _i876;
import 'package:djangui/features/budgets/data/datasources/budget_local_datasource.dart'
    as _i999;
import 'package:djangui/features/budgets/data/datasources/budget_remote_datasource.dart'
    as _i959;
import 'package:djangui/features/budgets/data/repositories/budget_repository_impl.dart'
    as _i45;
import 'package:djangui/features/budgets/domain/repositories/budget_repository.dart'
    as _i674;
import 'package:djangui/features/budgets/presentation/bloc/budgets_bloc.dart'
    as _i339;
import 'package:djangui/features/challenges/data/datasources/challenge_api_service.dart'
    as _i181;
import 'package:djangui/features/challenges/data/datasources/challenge_local_datasource.dart'
    as _i209;
import 'package:djangui/features/challenges/data/datasources/challenge_remote_datasource.dart'
    as _i540;
import 'package:djangui/features/challenges/data/repositories/challenge_repository_impl.dart'
    as _i558;
import 'package:djangui/features/challenges/domain/repositories/challenge_repository.dart'
    as _i1021;
import 'package:djangui/features/challenges/presentation/bloc/challenges_bloc.dart'
    as _i983;
import 'package:djangui/features/coach/data/datasources/coach_api_service.dart'
    as _i522;
import 'package:djangui/features/coach/data/datasources/coach_local_datasource.dart'
    as _i493;
import 'package:djangui/features/coach/data/datasources/coach_remote_datasource.dart'
    as _i186;
import 'package:djangui/features/coach/data/repositories/coach_repository_impl.dart'
    as _i364;
import 'package:djangui/features/coach/domain/repositories/coach_repository.dart'
    as _i745;
import 'package:djangui/features/coach/presentation/bloc/coach_bloc.dart'
    as _i1005;
import 'package:djangui/features/dashboard/presentation/bloc/dashboard_bloc.dart'
    as _i257;
import 'package:djangui/features/goals/data/datasources/goal_api_service.dart'
    as _i615;
import 'package:djangui/features/goals/data/datasources/goal_local_datasource.dart'
    as _i642;
import 'package:djangui/features/goals/data/datasources/goal_remote_datasource.dart'
    as _i912;
import 'package:djangui/features/goals/data/repositories/goal_repository_impl.dart'
    as _i511;
import 'package:djangui/features/goals/domain/repositories/goal_repository.dart'
    as _i824;
import 'package:djangui/features/goals/presentation/bloc/goals_bloc.dart'
    as _i424;
import 'package:djangui/features/insights/data/datasources/ai_api_service.dart'
    as _i391;
import 'package:djangui/features/insights/data/datasources/ai_remote_datasource.dart'
    as _i947;
import 'package:djangui/features/insights/data/datasources/insight_api_service.dart'
    as _i88;
import 'package:djangui/features/insights/data/repositories/insight_repository_impl.dart'
    as _i586;
import 'package:djangui/features/insights/domain/repositories/insight_repository.dart'
    as _i129;
import 'package:djangui/features/insights/presentation/bloc/insights_bloc.dart'
    as _i689;
import 'package:djangui/features/investments/data/datasources/investment_api_service.dart'
    as _i758;
import 'package:djangui/features/investments/data/repositories/investment_repository_impl.dart'
    as _i656;
import 'package:djangui/features/investments/domain/repositories/investment_repository.dart'
    as _i499;
import 'package:djangui/features/investments/presentation/bloc/investments_bloc.dart'
    as _i2;
import 'package:djangui/features/reports/data/datasources/reports_api_service.dart'
    as _i490;
import 'package:djangui/features/reports/data/repositories/reports_repository_impl.dart'
    as _i80;
import 'package:djangui/features/reports/domain/repositories/reports_repository.dart'
    as _i325;
import 'package:djangui/features/settings/presentation/bloc/settings_bloc.dart'
    as _i754;
import 'package:djangui/features/subscription/data/datasources/payment_api_service.dart'
    as _i816;
import 'package:djangui/features/system/data/datasources/system_api_service.dart'
    as _i477;
import 'package:djangui/features/system/data/repositories/system_repository_impl.dart'
    as _i510;
import 'package:djangui/features/system/domain/repositories/system_repository.dart'
    as _i326;
import 'package:djangui/features/transactions/data/datasources/transaction_api_service.dart'
    as _i70;
import 'package:djangui/features/transactions/data/datasources/transaction_local_datasource.dart'
    as _i1040;
import 'package:djangui/features/transactions/data/datasources/transaction_remote_datasource.dart'
    as _i231;
import 'package:djangui/features/transactions/data/repositories/transaction_repository_impl.dart'
    as _i406;
import 'package:djangui/features/transactions/domain/repositories/transaction_repository.dart'
    as _i461;
import 'package:djangui/features/transactions/presentation/bloc/transactions_bloc.dart'
    as _i492;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i275.NotificationService>(
        () => _i275.NotificationService());
    gh.lazySingleton<_i282.OCRService>(() => _i282.OCRService());
    gh.lazySingleton<_i69.ShareService>(() => _i69.ShareService());
    gh.lazySingleton<_i252.SMSService>(() => _i252.SMSService());
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => registerModule.secureStorage);
    gh.lazySingleton<_i31.ChopperClient>(() => registerModule.chopperClient);
    gh.lazySingleton<_i651.AuthApiService>(() => registerModule.authApiService);
    gh.lazySingleton<_i70.TransactionApiService>(
        () => registerModule.transactionApiService);
    gh.lazySingleton<_i876.BudgetApiService>(
        () => registerModule.budgetApiService);
    gh.lazySingleton<_i615.GoalApiService>(() => registerModule.goalApiService);
    gh.lazySingleton<_i181.ChallengeApiService>(
        () => registerModule.challengeApiService);
    gh.lazySingleton<_i522.CoachApiService>(
        () => registerModule.coachApiService);
    gh.lazySingleton<_i88.InsightApiService>(
        () => registerModule.insightApiService);
    gh.lazySingleton<_i391.AiApiService>(() => registerModule.aiApiService);
    gh.lazySingleton<_i758.InvestmentApiService>(
        () => registerModule.investmentApiService);
    gh.lazySingleton<_i816.PaymentApiService>(
        () => registerModule.paymentApiService);
    gh.lazySingleton<_i490.ReportsApiService>(
        () => registerModule.reportsApiService);
    gh.lazySingleton<_i730.AppDatabase>(() => registerModule.database);
    gh.lazySingleton<_i974.Logger>(() => registerModule.logger);
    gh.factory<_i754.SettingsBloc>(
        () => _i754.SettingsBloc(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i959.BudgetRemoteDataSource>(
        () => _i959.BudgetRemoteDataSourceImpl(gh<_i876.BudgetApiService>()));
    gh.lazySingleton<_i540.ChallengeRemoteDataSource>(() =>
        _i540.ChallengeRemoteDataSourceImpl(gh<_i181.ChallengeApiService>()));
    gh.lazySingleton<_i574.NetworkInfo>(() => _i574.NetworkInfoImpl());
    gh.lazySingleton<_i29.PaymentService>(
        () => _i29.PaymentService(gh<_i816.PaymentApiService>()));
    gh.lazySingleton<_i499.InvestmentRepository>(
        () => _i656.InvestmentRepositoryImpl(
              gh<_i730.AppDatabase>(),
              gh<_i758.InvestmentApiService>(),
            ));
    gh.factory<_i2.InvestmentsBloc>(
        () => _i2.InvestmentsBloc(gh<_i499.InvestmentRepository>()));
    gh.lazySingleton<_i325.ReportsRepository>(() => _i80.ReportsRepositoryImpl(
          gh<_i490.ReportsApiService>(),
          gh<_i574.NetworkInfo>(),
        ));
    gh.lazySingleton<_i493.CoachLocalDataSource>(
        () => _i493.CoachLocalDataSourceImpl(gh<_i730.AppDatabase>()));
    gh.lazySingleton<_i209.ChallengeLocalDataSource>(
        () => _i209.ChallengeLocalDataSourceImpl(gh<_i730.AppDatabase>()));
    gh.lazySingleton<_i642.GoalLocalDataSource>(
        () => _i642.GoalLocalDataSourceImpl(gh<_i730.AppDatabase>()));
    gh.lazySingleton<_i326.SystemRepository>(
        () => _i510.SystemRepositoryImpl(gh<_i477.SystemApiService>()));
    gh.lazySingleton<_i520.AuthLocalDataSource>(
        () => _i520.AuthLocalDataSourceImpl(
              gh<_i558.FlutterSecureStorage>(),
              gh<_i730.AppDatabase>(),
              gh<_i974.Logger>(),
            ));
    gh.lazySingleton<_i1021.ChallengeRepository>(
        () => _i558.ChallengeRepositoryImpl(
              gh<_i540.ChallengeRemoteDataSource>(),
              gh<_i209.ChallengeLocalDataSource>(),
              gh<_i574.NetworkInfo>(),
            ));
    gh.lazySingleton<_i912.GoalRemoteDataSource>(
        () => _i912.GoalRemoteDataSourceImpl(gh<_i615.GoalApiService>()));
    gh.lazySingleton<_i1040.TransactionLocalDataSource>(
        () => _i1040.TransactionLocalDataSourceImpl(gh<_i730.AppDatabase>()));
    gh.lazySingleton<_i999.BudgetLocalDataSource>(
        () => _i999.BudgetLocalDataSourceImpl(gh<_i730.AppDatabase>()));
    gh.lazySingleton<_i231.TransactionRemoteDataSource>(() =>
        _i231.TransactionRemoteDataSourceImpl(
            gh<_i70.TransactionApiService>()));
    gh.lazySingleton<_i947.AIRemoteDataSource>(
        () => _i947.AIRemoteDataSource(gh<_i391.AiApiService>()));
    gh.lazySingleton<_i129.InsightRepository>(() => _i586.InsightRepositoryImpl(
          gh<_i88.InsightApiService>(),
          gh<_i574.NetworkInfo>(),
        ));
    gh.lazySingleton<_i186.CoachRemoteDataSource>(
        () => _i186.CoachRemoteDataSourceImpl(gh<_i522.CoachApiService>()));
    gh.factory<_i257.DashboardBloc>(
        () => _i257.DashboardBloc(gh<_i325.ReportsRepository>()));
    gh.lazySingleton<_i1046.AuthRemoteDataSource>(
        () => _i1046.AuthRemoteDataSourceImpl(
              gh<_i651.AuthApiService>(),
              gh<_i520.AuthLocalDataSource>(),
            ));
    gh.lazySingleton<_i745.CoachRepository>(() => _i364.CoachRepositoryImpl(
          gh<_i186.CoachRemoteDataSource>(),
          gh<_i493.CoachLocalDataSource>(),
          gh<_i574.NetworkInfo>(),
        ));
    gh.lazySingleton<_i674.BudgetRepository>(() => _i45.BudgetRepositoryImpl(
          gh<_i959.BudgetRemoteDataSource>(),
          gh<_i999.BudgetLocalDataSource>(),
          gh<_i574.NetworkInfo>(),
        ));
    gh.factory<_i689.InsightsBloc>(
        () => _i689.InsightsBloc(gh<_i129.InsightRepository>()));
    gh.lazySingleton<_i316.SyncService>(() => _i316.SyncService(
          gh<_i730.AppDatabase>(),
          gh<_i231.TransactionRemoteDataSource>(),
          gh<_i974.Logger>(),
        ));
    gh.factory<_i983.ChallengesBloc>(
        () => _i983.ChallengesBloc(gh<_i1021.ChallengeRepository>()));
    gh.lazySingleton<_i461.TransactionRepository>(
        () => _i406.TransactionRepositoryImpl(
              gh<_i231.TransactionRemoteDataSource>(),
              gh<_i1040.TransactionLocalDataSource>(),
              gh<_i574.NetworkInfo>(),
              gh<_i730.AppDatabase>(),
            ));
    gh.factory<_i339.BudgetsBloc>(
        () => _i339.BudgetsBloc(gh<_i674.BudgetRepository>()));
    gh.lazySingleton<_i824.GoalRepository>(() => _i511.GoalRepositoryImpl(
          gh<_i912.GoalRemoteDataSource>(),
          gh<_i642.GoalLocalDataSource>(),
          gh<_i574.NetworkInfo>(),
        ));
    gh.lazySingleton<_i1012.AuthRepository>(() => _i29.AuthRepositoryImpl(
          gh<_i1046.AuthRemoteDataSource>(),
          gh<_i520.AuthLocalDataSource>(),
          gh<_i574.NetworkInfo>(),
        ));
    gh.factory<_i424.GoalsBloc>(
        () => _i424.GoalsBloc(gh<_i824.GoalRepository>()));
    gh.factory<_i1005.CoachBloc>(
        () => _i1005.CoachBloc(gh<_i745.CoachRepository>()));
    gh.factory<_i492.TransactionsBloc>(
        () => _i492.TransactionsBloc(gh<_i461.TransactionRepository>()));
    gh.lazySingleton<_i48.AuthBloc>(
        () => _i48.AuthBloc(gh<_i1012.AuthRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i153.RegisterModule {}
