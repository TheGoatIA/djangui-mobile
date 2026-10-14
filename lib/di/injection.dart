import 'package:chopper/chopper.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kauri/core/analytics/analytics_service.dart';
import 'package:kauri/core/services/log_service.dart';
import 'package:kauri/core/services/telemetry_service.dart';
import 'package:kauri/features/reseller/data/datasources/reseller_api_service.dart';
import 'package:kauri/features/reseller/domain/repositories/reseller_repository.dart';
import 'package:kauri/features/reseller/presentation/bloc/reseller_bloc.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  await getIt.init();
  // Manually register LogService to ensure it's available even if build_runner hasn't run
  if (!getIt.isRegistered<LogService>()) {
    getIt.registerLazySingleton<LogService>(() => LogService());
  }
  // Register AnalyticsService (wraps TelemetryService + Firebase Crashlytics/Performance)
  if (!getIt.isRegistered<AnalyticsService>()) {
    getIt.registerLazySingleton<AnalyticsService>(
      () =>
          KauriAnalyticsService(getIt<TelemetryService>(), getIt<LogService>()),
    );
  }

  // Register Reseller Module dependencies
  if (!getIt.isRegistered<ResellerApiService>()) {
    getIt.registerLazySingleton<ResellerApiService>(
      () => ResellerApiService.create(getIt<ChopperClient>()),
    );
  }
  if (!getIt.isRegistered<ResellerRepository>()) {
    getIt.registerLazySingleton<ResellerRepository>(
      () => ResellerRepository(getIt<ResellerApiService>()),
    );
  }
  if (!getIt.isRegistered<ResellerBloc>()) {
    getIt.registerFactory<ResellerBloc>(
      () => ResellerBloc(getIt<ResellerRepository>()),
    );
  }
}
