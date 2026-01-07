import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/device_info_request.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, void>> verifyPhoneNumber(
    String phoneNumber, {
    required Function(String verificationId) onCodeSent,
    required Function(String errorMessage) onVerificationFailed,
  }) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification handled in signInWithPhoneNumber if possible
        },
        verificationFailed: (FirebaseAuthException e) {
          onVerificationFailed(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> signInWithPhoneNumber(
    String verificationId,
    String smsCode,
  ) async {
    if (!await _networkInfo.isConnected) return Left(NetworkFailure());

    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      final String? idToken = await userCredential.user?.getIdToken();

      if (idToken == null) return Left(AuthFailure('No ID Token found'));

      final response = await _remoteDataSource.firebaseLogin(idToken);
      await _localDataSource.saveTokens(
        accessToken: response.tokens.accessToken,
        refreshToken: response.tokens.refreshToken,
      );
      await _localDataSource.saveUser(response.user);
      return Right(response);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> linkPhoneNumber(
    String verificationId,
    String smsCode,
  ) async {
    if (!await _networkInfo.isConnected) return Left(NetworkFailure());

    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // Link with current Firebase user if any, or just get token
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        // If not signed in to Firebase, sign in first to get token
        final result = await FirebaseAuth.instance.signInWithCredential(
          credential,
        );
        final idToken = await result.user?.getIdToken();
        if (idToken != null) {
          await _remoteDataSource.linkPhone(idToken);
        }
      } else {
        await currentUser.linkWithCredential(credential);
        final idToken = await currentUser.getIdToken();
        if (idToken != null) {
          await _remoteDataSource.linkPhone(idToken);
        }
      }
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> signInWithGoogle() async {
    if (!await _networkInfo.isConnected) return Left(NetworkFailure());

    try {
      await _googleSignIn.initialize();
      final googleUser = await _googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) return Left(AuthFailure('No ID Token found'));

      final response = await _remoteDataSource.firebaseLogin(idToken);
      await _localDataSource.saveTokens(
        accessToken: response.tokens.accessToken,
        refreshToken: response.tokens.refreshToken,
      );
      await _localDataSource.saveUser(response.user);
      return Right(response);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateProfile({
    String? firstName,
    String? lastName,
    String? country,
    String? avatar,
    double? monthlyIncome,
  }) async {
    if (!await _networkInfo.isConnected) return Left(NetworkFailure());

    try {
      final user = await _remoteDataSource.updateProfile(
        firstName: firstName,
        lastName: lastName,
        country: country,
        avatar: avatar,
        monthlyIncome: monthlyIncome,
      );
      await _localDataSource.saveUser(user);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> login(LoginRequest request) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.login(request);
        await _localDataSource.saveTokens(
          accessToken: response.tokens.accessToken,
          refreshToken: response.tokens.refreshToken,
        );
        await _localDataSource.saveUser(response.user);
        return Right(response);
      } catch (e) {
        return Left(AuthFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> register(
    RegisterRequest request,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.register(request);
        await _localDataSource.saveTokens(
          accessToken: response.tokens.accessToken,
          refreshToken: response.tokens.refreshToken,
        );
        await _localDataSource.saveUser(response.user);
        return Right(response);
      } catch (e) {
        return Left(AuthFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, UserModel>> getCurrentUser() async {
    try {
      final user = await _localDataSource.getUser();
      if (user != null) {
        return Right(user);
      }
      return Left(CacheFailure());
    } catch (e, stack) {
      debugPrint('🔑 [AuthRepository] Error fetching current user: $e');
      debugPrint(stack.toString());
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // 1. Call remote logout if needed (optional)
      // await _remoteDataSource.logout();

      // 2. Clear local storage
      await _localDataSource.clearTokens();

      // 3. Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // 4. Sign out from Google
      try {
        await _googleSignIn.signOut();
      } catch (_) {
        // Ignore errors if not signed in or other issues
      }

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _localDataSource.getAccessToken();
    return token != null;
  }

  @override
  Future<String?> getAccessToken() async {
    return _localDataSource.getAccessToken();
  }

  @override
  Future<String?> getRefreshToken() async {
    return _localDataSource.getRefreshToken();
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.forgotPassword(email);
        return const Right(null);
      } catch (e) {
        return Left(AuthFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(
    String token,
    String newPassword,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.resetPassword(token, newPassword);
        return const Right(null);
      } catch (e) {
        return Left(AuthFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail(String token) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.verifyEmail(token);
        return const Right(null);
      } catch (e) {
        return Left(AuthFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> refreshToken() async {
    final refreshToken = await _localDataSource.getRefreshToken();
    if (refreshToken == null) {
      return Left(AuthFailure('No refresh token found'));
    }

    if (await _networkInfo.isConnected) {
      try {
        debugPrint('🌐 [AuthRepository] Refreshing token...');
        final tokens = await _remoteDataSource.refreshToken(refreshToken);
        await _localDataSource.saveTokens(
          accessToken: tokens['accessToken']!,
          refreshToken: tokens['refreshToken']!,
        );
        debugPrint('🌐 [AuthRepository] Token refreshed successfully');
        return const Right(null);
      } catch (e) {
        debugPrint('🌐 [AuthRepository] Token refresh failed: $e');
        return Left(AuthFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateFcmToken(String token) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.updateFcmToken(token);
        return const Right(null);
      } catch (e) {
        return Left(AuthFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<void> updateDeviceInfo() async {
    if (await _networkInfo.isConnected) {
      try {
        final deviceInfoPlugin = DeviceInfoPlugin();
        final packageInfo = await PackageInfo.fromPlatform();
        String model = 'Unknown';
        String os = 'Unknown';
        String osVersion = 'Unknown';
        String platform = 'unknown';

        if (Platform.isAndroid) {
          final androidInfo = await deviceInfoPlugin.androidInfo;
          model = '${androidInfo.manufacturer} ${androidInfo.model}';
          os = 'Android';
          osVersion = androidInfo.version.release;
          platform = 'android';
        } else if (Platform.isIOS) {
          final iosInfo = await deviceInfoPlugin.iosInfo;
          model = iosInfo.utsname.machine;
          os = 'iOS';
          osVersion = iosInfo.systemVersion;
          platform = 'ios';
        }

        final request = DeviceInfoRequest(
          deviceInfo: DeviceInfoDetails(
            model: model,
            os: os,
            osVersion: osVersion,
            platform: platform,
          ),
          appVersion: packageInfo.version,
        );

        await _remoteDataSource.updateDeviceInfo(request);
      } catch (e) {
        debugPrint('⚠️ [AuthRepository] Failed to update device info: $e');
        // We generally don't want to throw/return failure for this background task
      }
    }
  }
}
