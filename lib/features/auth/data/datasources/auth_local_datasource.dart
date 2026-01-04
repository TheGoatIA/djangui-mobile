import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/database.dart';
import '../models/user_model.dart';
import '../models/badge_model.dart';
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
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _storage;
  final AppDatabase _db;

  AuthLocalDataSourceImpl(this._storage, this._db);

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

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
    return await _storage.read(key: _accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  @override
  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _db.delete(_db.users).go();
  }

  @override
  Future<void> saveUser(UserModel user) async {
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
          ),
        );
  }

  @override
  Future<UserModel?> getUser() async {
    final user = await _db.select(_db.users).getSingleOrNull();
    if (user == null) return null;
    return UserModel(
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      avatar: user.avatar,
      xp: user.xp,
      level: user.level,
      badges: (jsonDecode(user.badges) as List)
          .map((e) => BadgeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      phone: '', // These would need to be added to the database schema too
      isEmailVerified: false,
      isPhoneVerified: false,
      role: 'user',
      status: 'active',
    );
  }
}
