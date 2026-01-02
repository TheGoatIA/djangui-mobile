import 'package:injectable/injectable.dart';
import 'auth_api_service.dart';

import '../models/auth_response.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> register(RegisterRequest request);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiService _apiService;

  AuthRemoteDataSourceImpl(this._apiService);

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _apiService.login(request);
    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      throw Exception(response.error?.toString() ?? 'Login failed');
    }
  }

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await _apiService.register(request);
    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      throw Exception(response.error?.toString() ?? 'Registration failed');
    }
  }
}
