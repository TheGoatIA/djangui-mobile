import 'package:injectable/injectable.dart';
import 'auth_api_service.dart';

import '../models/auth_response.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> googleLogin(String token);
  Future<AuthResponse> register(RegisterRequest request);
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String token, String newPassword);
  Future<void> verifyEmail(String token);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiService _apiService;

  AuthRemoteDataSourceImpl(this._apiService);

  @override
  Future<AuthResponse> googleLogin(String token) async {
    final response = await _apiService.googleLogin({'token': token});
    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      throw Exception(response.error?.toString() ?? 'Google login failed');
    }
  }

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

  @override
  Future<void> forgotPassword(String email) async {
    final response = await _apiService.forgotPassword({'email': email});
    if (!response.isSuccessful) {
      throw Exception(response.error?.toString() ?? 'Forgot password failed');
    }
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    final response = await _apiService.resetPassword(token, {
      'password': newPassword,
    });
    if (!response.isSuccessful) {
      throw Exception(response.error?.toString() ?? 'Reset password failed');
    }
  }

  @override
  Future<void> verifyEmail(String token) async {
    final response = await _apiService.verifyEmail(token);
    if (!response.isSuccessful) {
      throw Exception(
        response.error?.toString() ?? 'Email verification failed',
      );
    }
  }
}
