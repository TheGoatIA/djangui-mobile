import 'package:chopper/chopper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../core/network/api_client.dart';
import '../core/database/database.dart';
import '../features/auth/data/datasources/auth_api_service.dart';
import 'injection.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @lazySingleton
  ChopperClient get chopperClient => DjanguiApiClient.create();

  @lazySingleton
  AuthApiService get authApiService =>
      AuthApiService.create(getIt<ChopperClient>());

  @lazySingleton
  AppDatabase get database => AppDatabase();
}
