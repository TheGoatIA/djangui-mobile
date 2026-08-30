import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:kauri/core/database/database.dart';
import 'package:kauri/core/services/biometric_gated_storage.dart';
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
  final BiometricGatedStorage _biometricStorage;

  AuthLocalDataSourceImpl(
    this._storage,
    this._db,
    this._logger,
    this._biometricStorage,
  );

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _providerKey = 'login_provider';

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
    // A device can be shared between users (logout/login by different people) —
    // every locally-cached table must be wiped here, not just the ones a given
    // feature happened to have when this method was first written. Missing a
    // table here means the next user to log in on this device can see the
    // previous user's cached data (tontines, contributions, subscriptions...)
    // until/unless a fresh sync happens to overwrite it.
    await _db.delete(_db.users).go();
    await _db.delete(_db.transactions).go();
    await _db.delete(_db.budgets).go();
    await _db.delete(_db.goals).go();
    await _db.delete(_db.challenges).go();
    await _db.delete(_db.investments).go();
    await _db.delete(_db.chatMessages).go();
    await _db.delete(_db.syncRequests).go();
    await _db.delete(_db.userSubscriptions).go();
    await _db.delete(_db.userChallenges).go();
    await _db.delete(_db.tontineContributions).go();
    await _db.delete(_db.tontineMessages).go();
    await _db.delete(_db.tontineMembers).go();
    await _db.delete(_db.tontines).go();
    // Caches ajoutés pour Insights/Dashboard (persistance locale + prévision
    // + historique du score de santé) : mêmes précautions, données propres à
    // un utilisateur (solde, revenus, catégories de dépenses, rapport IA...).
    await _db.delete(_db.dashboardReports).go();
    await _db.delete(_db.spendingAnalysisCache).go();
    await _db.delete(_db.savingsTrendCache).go();
    await _db.delete(_db.narrativeReportCache).go();
    await _db.delete(_db.forecastCache).go();
    await _db.delete(_db.healthScoreHistoryCache).go();
    await clearBiometricToken();
    await clearLoginProvider();
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
    _logger.d('💾 [AuthLocal] Saving biometric token (Keystore/Keychain biométrique)');
    await _biometricStorage.write(token);
  }

  @override
  Future<String?> getBiometricToken() async {
    // Déclenche l'invite biométrique native ici même — pas de vérification
    // Dart séparée à contourner, le déchiffrement lui-même l'exige.
    final token = await _biometricStorage.read();
    _logger.d('💾 [AuthLocal] Fetching biometric token: ${token != null}');
    return token;
  }

  @override
  Future<void> clearBiometricToken() async {
    await _biometricStorage.delete();
  }
}
