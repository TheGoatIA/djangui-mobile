import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:kauri/core/database/database.dart';
import 'package:kauri/features/auth/data/models/user_model.dart';
import 'package:kauri/features/auth/data/models/badge_model.dart';
import 'package:drift/drift.dart' as drift;

abstract class AuthLocalDataSource {
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> clearTokens();
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> saveCredentials(String email, String password);
  Future<Map<String, String>?> getCredentials();
  Future<void> clearCredentials();
  Future<void> saveLoginProvider(String provider);
  Future<String?> getLoginProvider();
  Future<void> clearLoginProvider();
  Future<void> saveBiometricToken(String token);
  Future<String?> getBiometricToken();
  Future<void> clearBiometricToken();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _storage;
  final AppDatabase _db;
  final Logger _logger;

  AuthLocalDataSourceImpl(this._storage, this._db, this._logger);

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _emailKey = 'login_email';
  static const _passwordKey = 'login_password';
  static const _providerKey = 'login_provider';
  static const _biometricTokenKey = 'biometric_token';

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  @override
  Future<String?> getAccessToken() async {
    final token = await _storage.read(key: _accessTokenKey);
    _logger.d('💾 [AuthLocal] Access token found: ${token != null}');
    return token;
  }

  @override
  Future<String?> getRefreshToken() async {
    final token = await _storage.read(key: _refreshTokenKey);
    _logger.d('💾 [AuthLocal] Refresh token found: ${token != null}');
    return token;
  }

  @override
  Future<void> clearTokens() async {
    _logger.d('💾 [AuthLocal] Clearing all tokens and user data');
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    // Clear all user-related data from tables
    await _db.delete(_db.users).go();
    await _db.delete(_db.transactions).go();
    await _db.delete(_db.budgets).go();
    await _db.delete(_db.goals).go();
    await _db.delete(_db.challenges).go();
    await _db.delete(_db.investments).go();
    await _db.delete(_db.chatMessages).go();
    await _db.delete(_db.syncRequests).go();
  }

  @override
  Future<void> saveUser(UserModel user) async {
    _logger.d('💾 [AuthLocal] Saving user to database: ${user.email}');
    await _db
        .into(_db.users)
        .insertOnConflictUpdate(
          UsersCompanion(
            id: drift.Value(user.id),
            email: drift.Value(user.email),
            firstName: drift.Value(user.firstName),
            lastName: drift.Value(user.lastName),
            avatar: drift.Value(user.avatar),
            xp: drift.Value(user.xp),
            level: drift.Value(user.level),
            badges: drift.Value(jsonEncode(user.badges)),
            isPremium: drift.Value(user.isPremium),
            country: drift.Value(user.country),
            phone: drift.Value(user.phone),
            language: drift.Value(user.language ?? 'fr'),
          ),
        );
  }

  @override
  Future<UserModel?> getUser() async {
    _logger.d('💾 [AuthLocal] Fetching user from database...');
    final user = await _db.select(_db.users).getSingleOrNull();
    _logger.d('💾 [AuthLocal] User found in database: ${user != null}');
    if (user == null) return null;

    return UserModel(
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      avatar: user.avatar,
      country: user.country,
      phone: user.phone,
      isPremium: user.isPremium,
      language: user.language,
      xp: user.xp,
      level: user.level,
      badges: (jsonDecode(user.badges) as List)
          .map((e) => BadgeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      // Fields not yet in DB (using defaults)
      isEmailVerified: false,
      isPhoneVerified: false,
      role: 'user',
      status: 'active',
      walletBalance: 0.0,
    );
  }

  @override
  Future<void> saveCredentials(String email, String password) async {
    _logger.d('💾 [AuthLocal] Saving credentials for biometric login: $email');
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _passwordKey, value: password);
  }

  @override
  Future<Map<String, String>?> getCredentials() async {
    final email = await _storage.read(key: _emailKey);
    final password = await _storage.read(key: _passwordKey);
    _logger.d(
      '💾 [AuthLocal] Fetching credentials: ${email != null ? "Found" : "Not Found"}',
    );
    if (email != null && password != null) {
      return {'email': email, 'password': password};
    }
    return null;
  }

  @override
  Future<void> clearCredentials() async {
    await _storage.delete(key: _emailKey);
    await _storage.delete(key: _passwordKey);
  }

  @override
  Future<void> saveLoginProvider(String provider) async {
    _logger.d('💾 [AuthLocal] Saving login provider: $provider');
    await _storage.write(key: _providerKey, value: provider);
  }

  @override
  Future<String?> getLoginProvider() async {
    final provider = await _storage.read(key: _providerKey);
    _logger.d('💾 [AuthLocal] Fetching login provider: $provider');
    return provider;
  }

  @override
  Future<void> clearLoginProvider() async {
    await _storage.delete(key: _providerKey);
  }

  @override
  Future<void> saveBiometricToken(String token) async {
    _logger.d('💾 [AuthLocal] Saving biometric token');
    await _storage.write(key: _biometricTokenKey, value: token);
  }

  @override
  Future<String?> getBiometricToken() async {
    final token = await _storage.read(key: _biometricTokenKey);
    _logger.d('💾 [AuthLocal] Fetching biometric token: ${token != null}');
    return token;
  }

  @override
  Future<void> clearBiometricToken() async {
    await _storage.delete(key: _biometricTokenKey);
  }
}
