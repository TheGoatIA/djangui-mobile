import 'package:injectable/injectable.dart';
import 'auth_api_service.dart';
import 'auth_local_datasource.dart';

import '../models/auth_response.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/user_model.dart';
import '../models/device_info_request.dart';
import '../../../../core/network/api_response_extensions.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> firebaseLogin(String idToken, {String? country});
  Future<void> linkPhone(String idToken);
  Future<AuthResponse> register(RegisterRequest request);
  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? country,
    String? avatar,
  });
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String token, String newPassword);
  Future<void> verifyEmail(String token);
  Future<Map<String, String>> refreshToken(String refreshToken);
  Future<void> updateFcmToken(String token);
  Future<void> updateDeviceInfo(DeviceInfoRequest request);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiService _apiService;
  final AuthLocalDataSource _localDataSource;

  AuthRemoteDataSourceImpl(this._apiService, this._localDataSource);

  @override
  Future<AuthResponse> firebaseLogin(String idToken, {String? country}) async {
    final response = await _apiService.firebaseLogin({
      'idToken': idToken,
      if (country != null) 'country': country,
    });
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<void> linkPhone(String idToken) async {
    final response = await _apiService.linkPhone({'idToken': idToken});
    if (!response.isSuccessful) {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _apiService.login(request);
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await _apiService.register(request);
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? country,
    String? avatar,
  }) async {
    final response = await _apiService.updateProfile({
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (country != null) 'country': country,
      if (avatar != null) 'avatar': avatar,
    });

    if (response.isSuccessful && response.body?.data != null) {
      final Map<String, dynamic> responseData = response.body!.data!;
      // Extract the user object if it's wrapped (as shown in the example)
      final Map<String, dynamic> userData = responseData.containsKey('user')
          ? Map<String, dynamic>.from(responseData['user'])
          : responseData;

      final currentUser = await _localDataSource.getUser();

      if (currentUser != null) {
        // Merge the updated fields with current user data
        final currentJson = currentUser.toJson();
        // Ensure _id is present for UserModel.fromJson
        if (userData.containsKey('id') && !userData.containsKey('_id')) {
          userData['_id'] = userData['id'];
        }
        currentJson.addAll(userData);
        return UserModel.fromJson(currentJson);
      }

      // If no local user, try to create one from the response
      // Ensure _id is present for UserModel.fromJson
      if (userData.containsKey('id') && !userData.containsKey('_id')) {
        userData['_id'] = userData['id'];
      }
      return UserModel.fromJson(userData);
    } else {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    final response = await _apiService.forgotPassword({'email': email});
    if (!response.isSuccessful) {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    final response = await _apiService.resetPassword(token, {
      'password': newPassword,
    });
    if (!response.isSuccessful) {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<void> verifyEmail(String token) async {
    final response = await _apiService.verifyEmail(token);
    if (!response.isSuccessful) {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<Map<String, String>> refreshToken(String refreshToken) async {
    final response = await _apiService.refreshToken({
      'refreshToken': refreshToken,
    });

    if (response.isSuccessful && response.body?.data != null) {
      final data = response.body!.data!;
      final tokens = data['tokens'] as Map<String, dynamic>;
      return {
        'accessToken': tokens['accessToken'] as String,
        'refreshToken': tokens['refreshToken'] as String,
      };
    } else {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<void> updateFcmToken(String token) async {
    final response = await _apiService.updateFcmToken({'fcmToken': token});
    if (!response.isSuccessful) {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<void> updateDeviceInfo(DeviceInfoRequest request) async {
    final response = await _apiService.updateDeviceInfo(request);
    if (!response.isSuccessful) {
      throw Exception(response.errorMessage);
    }
  }
}
