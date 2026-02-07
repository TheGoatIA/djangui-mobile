import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kauri/core/services/log_service.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  await getIt.init();
  // Manually register LogService to ensure it's available even if build_runner hasn't run
  if (!getIt.isRegistered<LogService>()) {
    getIt.registerLazySingleton<LogService>(() => LogService());
  }
}
