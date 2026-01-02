import 'package:chopper/chopper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/api_client.dart';
import '../core/database/database.dart';
import '../features/auth/data/datasources/auth_api_service.dart';
import '../features/transactions/data/datasources/transaction_api_service.dart';
import 'injection.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @lazySingleton
  ChopperClient get chopperClient => DjanguiApiClient.create();

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  AuthApiService get authApiService =>
      AuthApiService.create(getIt<ChopperClient>());

  @lazySingleton
  TransactionApiService get transactionApiService =>
      TransactionApiService.create(getIt<ChopperClient>());

  @lazySingleton
  AppDatabase get database => AppDatabase();
}
