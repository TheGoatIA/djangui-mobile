import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:kauri/features/auth/data/datasources/auth_api_service.dart';
import 'package:kauri/features/auth/data/datasources/auth_local_datasource.dart';

import 'package:kauri/features/auth/data/models/auth_response.dart';
import 'package:kauri/features/auth/data/models/login_request.dart';
import 'package:kauri/features/auth/data/models/register_request.dart';
import 'package:kauri/features/auth/data/models/user_model.dart';
import 'package:kauri/features/auth/data/models/device_info_request.dart';
import 'package:kauri/features/auth/data/models/connection_request.dart';
import 'package:kauri/features/auth/data/models/session_model.dart';
import 'package:kauri/features/auth/data/models/country_change_request.dart';
import 'package:kauri/core/network/api_response_extensions.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> firebaseLogin(String idToken, {String? country});
  Future<AuthResponse> appleLogin(String idToken, {String? countryCode});
  Future<void> linkPhone(String idToken);
  Future<AuthResponse> register(RegisterRequest request);
  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? country,
    String? avatar,
    double? monthlyIncome,
    UserPreferences? preferences,
  });
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String token, String newPassword);
  Future<void> verifyEmail(String token);
  Future<Map<String, String>> refreshToken(String refreshToken);
  Future<void> updateFcmToken(String token);
  Future<void> updateDeviceInfo(DeviceInfoRequest request);
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<void> deleteAccount();
  Future<List<SessionModel>> getSessions();
  Future<void> revokeSession(String sessionId);
  Future<void> revokeAllOtherSessions();
  Future<UserModel> getCurrentUser();
  Future<void> logConnection(ConnectionRequest request);
  Future<CountryChangeRequestModel> requestCountryChange(String countryCode);
  Future<void> updateLanguage(String languageCode);
  Future<Map<String, dynamic>> submitKYC({
    required String documentType,
    required String documentNumber,
    required String fullName,
    required String documentImageUrl,
    required String selfieImageUrl,
  });
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
    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<AuthResponse> appleLogin(String idToken, {String? countryCode}) async {
    final response = await _apiService.appleLogin({
      'idToken': idToken,
      if (countryCode != null) 'country': countryCode,
    });
    if (response.isSuccessful && response.body != null) {
      return response.body!;
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
    debugPrint(
      '🌐 [AuthRemoteDataSource] Registering user with: ${request.toJson()}',
    );
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
    double? monthlyIncome,
    UserPreferences? preferences,
  }) async {
    final response = await _apiService.updateProfile({
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (country != null) 'country': country,
      if (avatar != null) 'avatar': avatar,
      if (monthlyIncome != null) 'monthlyIncome': monthlyIncome,
      if (preferences != null) 'preferences': preferences.toJson(),
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

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final response = await _apiService.changePassword({
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
    if (!response.isSuccessful) {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<void> deleteAccount() async {
    final response = await _apiService.deleteAccount();
    if (!response.isSuccessful) {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<List<SessionModel>> getSessions() async {
    final response = await _apiService.getSessions();
    if (response.isSuccessful && response.body?.data != null) {
      try {
        final data = response.body!.data as Map<String, dynamic>;
        final sessionsJson = data['sessions'] as List<dynamic>?;

        if (sessionsJson == null) return [];

        final List<SessionModel> sessions = [];
        for (final s in sessionsJson) {
          if (s is Map<String, dynamic>) {
            try {
              sessions.add(SessionModel.fromJson(s));
            } catch (e) {
              // Log the specific session that failed
              debugPrint('❌ Error parsing session: $e\nSession data: $s');
            }
          }
        }
        return sessions;
      } catch (e) {
        throw Exception('Error processing sessions data: $e');
      }
    } else {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<void> revokeSession(String sessionId) async {
    final response = await _apiService.revokeSession(sessionId);
    if (!response.isSuccessful) {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<void> revokeAllOtherSessions() async {
    final response = await _apiService.revokeAllOtherSessions();
    if (!response.isSuccessful) {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await _apiService.getUserProfile();
    if (response.isSuccessful && response.body?.data != null) {
      final data = response.body!.data!;
      // Handle wrapped user object if present
      final userMap = data.containsKey('user')
          ? Map<String, dynamic>.from(data['user'] as Map<String, dynamic>)
          : Map<String, dynamic>.from(data);

      Map<String, dynamic> finalJson = userMap;

      // If the wrapped object (or direct object) is missing _id but has keys alongside it?
      // Wait, if data has 'user' AND '_id', we prioritize 'user'.

      // Merge top-level fields into userMap if they are missing?
      // Actually, looking at the log: data has 'user', AND '_id', 'email' etc at top level.
      // But 'user' object also has 'preferences', 'subscription' etc.
      // It seems 'data' IS the user object but ALSO contains a 'user' field?
      // No, the error said 'Null is not subtype of String' when treating data as UserModel.
      // If data was treated as UserModel, and it had _id (from log), it should have worked.
      // UNLESS the log I saw was partially misleading or I misinterpreted which keys are where.

      // Safest approach:
      // If 'user' key exists and is a Map, use it.
      // Ensure _id exists.

      if (finalJson.containsKey('id') && !finalJson.containsKey('_id')) {
        finalJson['_id'] = finalJson['id'];
      }

      return UserModel.fromJson(finalJson);
    } else {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<void> logConnection(ConnectionRequest request) async {
    final response = await _apiService.logConnection(request);
    if (!response.isSuccessful) {
      debugPrint(
        '⚠️ [AuthRemoteDataSource] Failed to log connection: ${response.errorMessage}',
      );
    }
  }

  @override
  Future<CountryChangeRequestModel> requestCountryChange(
    String countryCode,
  ) async {
    final response = await _apiService.requestCountryChange({
      'countryCode': countryCode,
    });
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<void> updateLanguage(String languageCode) async {
    final response = await _apiService.updateLanguage({
      'language': languageCode,
    });
    if (!response.isSuccessful) {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<Map<String, dynamic>> submitKYC({
    required String documentType,
    required String documentNumber,
    required String fullName,
    required String documentImageUrl,
    required String selfieImageUrl,
  }) async {
    final response = await _apiService.submitKYC({
      'documentType': documentType,
      'documentNumber': documentNumber,
      'fullName': fullName,
      'documentImageUrl': documentImageUrl,
      'selfieImageUrl': selfieImageUrl,
    });

    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(response.errorMessage);
    }
  }
}
