import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
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
import '../models/connection_request.dart';
import '../models/session_model.dart';
import '../models/country_change_request.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kauri/core/services/log_service.dart';
import '../../../../di/injection.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Implémentation concrète de [AuthRepository].
///
/// Cette classe gère l'orchestration entre les sources de données distantes (API, Firebase)
/// et locales (Secure Storage, SharedPreferences), tout en gérant les états de connexion.
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

  LogService get _logger => getIt<LogService>();

  @override
  Future<Either<Failure, void>> verifyPhoneNumber(
    String phoneNumber, {
    required Function(String verificationId) onCodeSent,
    required Function(String errorMessage) onVerificationFailed,
  }) async {
    try {
      // Utilisation de Firebase Phone Auth pour l'envoi du SMS de vérification.
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // La validation automatique n'est pas gérée ici pour laisser le contrôle au bloc.
        },
        verificationFailed: (FirebaseAuthException e) {
          onVerificationFailed(e.message ?? 'Échec de la vérification');
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
    String smsCode, {
    String? country,
  }) async {
    if (!await _networkInfo.isConnected) return Left(NetworkFailure());

    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // Authentifie l'utilisateur sur Firebase d'abord.
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      final String? idToken = await userCredential.user?.getIdToken();

      if (idToken == null) return Left(AuthFailure('Jeton ID introuvable'));

      // Puis échange le jeton Firebase contre une session sur le backend Kauri.
      final response = await _remoteDataSource.firebaseLogin(
        idToken,
        country: country,
      );
      await _localDataSource.saveTokens(
        accessToken: response.tokens.accessToken,
        refreshToken: response.tokens.refreshToken,
      );
      await _localDataSource.saveUser(response.user);
      await _localDataSource.saveLoginProvider('phone');
      _logger.info(
        'Authentification réussie par téléphone',
        component: 'AuthRepository',
        metadata: {'userId': response.user.id},
      );
      return Right(response);
    } catch (e) {
      _logger.error(
        'Échec de la connexion par téléphone',
        error: e,
        component: 'AuthRepository',
      );
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
        // Check if user is already linked to phone provider
        final isPhoneLinked = currentUser.providerData.any(
          (userInfo) => userInfo.providerId == 'phone',
        );

        if (isPhoneLinked) {
          try {
            await currentUser.unlink('phone');
          } catch (e) {
            debugPrint('⚠️ Failed to unlink old phone number: $e');
            // Continue to try detecting if it was indeed the issue,
            // or maybe the user has ONLY phone linked (which cannot be unlinked usually if it's the only one?
            // actually Firebase allows unlinking if you have another provider, or it might just fail).
            // But we try to proceed or fail here.
          }
        }

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
  Future<Either<Failure, AuthResponse>> signInWithGoogle({
    String? countryCode,
  }) async {
    if (!await _networkInfo.isConnected) return Left(NetworkFailure());

    try {
      // Nettoyage de l'état précédent pour éviter les erreurs persistantes sur Android.
      await _googleSignIn.signOut();
      await _googleSignIn.initialize();
      final googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        return Left(AuthFailure('Jeton Google ID introuvable'));
      }

      // 1. Échange du jeton Google contre des identifiants Firebase.
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      // 2. Connexion à Firebase.
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      // 3. Récupération du jeton Firebase ID (nécessaire pour authentifier l'API backend).
      final String? firebaseIdToken = await userCredential.user?.getIdToken();

      if (firebaseIdToken == null) {
        return Left(AuthFailure('Échec de la récupération du jeton Firebase'));
      }

      // 4. Envoi du jeton Firebase au backend principal.
      final response = await _remoteDataSource.firebaseLogin(
        firebaseIdToken,
        country: countryCode,
      );

      await _localDataSource.saveTokens(
        accessToken: response.tokens.accessToken,
        refreshToken: response.tokens.refreshToken,
      );
      await _localDataSource.saveUser(response.user);
      await _localDataSource.saveLoginProvider('google');
      _logger.info(
        'Authentification réussie par Google',
        component: 'AuthRepository',
        metadata: {'userId': response.user.id},
      );
      return Right(response);
    } catch (e) {
      _logger.error(
        'Échec de la connexion par Google',
        error: e,
        component: 'AuthRepository',
      );
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> signInWithApple({
    String? countryCode,
  }) async {
    if (!await _networkInfo.isConnected) return Left(NetworkFailure());

    try {
      final rawNonce = _generateNonce();
      final hashedNonce = _sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      final identityToken = appleCredential.identityToken;
      if (identityToken == null) {
        return Left(AuthFailure('No Identity Token found'));
      }

      // 1. Sign in to Firebase with Apple credentials
      final AuthCredential credential = OAuthProvider(
        'apple.com',
      ).credential(idToken: identityToken, rawNonce: rawNonce);

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      // 2. Get the Firebase ID Token
      final String? firebaseIdToken = await userCredential.user?.getIdToken();

      if (firebaseIdToken == null) {
        return Left(AuthFailure('Failed to get Firebase ID Token'));
      }

      // 3. Send Firebase ID Token to backend
      final response = await _remoteDataSource.firebaseLogin(
        firebaseIdToken,
        country: countryCode,
      );

      await _localDataSource.saveTokens(
        accessToken: response.tokens.accessToken,
        refreshToken: response.tokens.refreshToken,
      );
      await _localDataSource.saveUser(response.user);
      await _localDataSource.saveLoginProvider('apple');
      _logger.info(
        'Authentification réussie par Apple',
        component: 'AuthRepository',
        metadata: {'userId': response.user.id},
      );
      return Right(response);
    } catch (e) {
      _logger.error(
        'Échec de la connexion par Apple',
        error: e,
        component: 'AuthRepository',
      );
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
    UserPreferences? preferences,
  }) async {
    if (!await _networkInfo.isConnected) return Left(NetworkFailure());

    try {
      final user = await _remoteDataSource.updateProfile(
        firstName: firstName,
        lastName: lastName,
        country: country,
        avatar: avatar,
        monthlyIncome: monthlyIncome,
        preferences: preferences,
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
        // Sauvegarde persistante des jetons et de l'utilisateur.
        await _localDataSource.saveTokens(
          accessToken: response.tokens.accessToken,
          refreshToken: response.tokens.refreshToken,
        );
        await _localDataSource.saveUser(response.user);
        await _localDataSource.saveLoginProvider('password');
        // Sauvegarde des identifiants chiffrés pour permettre la connexion biométrique ultérieure.
        await _localDataSource.saveCredentials(request.email, request.password);
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
        await _localDataSource.saveLoginProvider('password');
        // Save credentials for biometrics
        await _localDataSource.saveCredentials(request.email, request.password);
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
    if (await _networkInfo.isConnected) {
      try {
        final user = await _remoteDataSource.getCurrentUser().timeout(
          const Duration(seconds: 5),
        );
        await _localDataSource.saveUser(user);
        return Right(user);
      } catch (e) {
        // Fallback to local cache if network fails
        final user = await _localDataSource.getUser();
        if (user != null) return Right(user);
        return Left(AuthFailure(e.toString()));
      }
    } else {
      final user = await _localDataSource.getUser();
      if (user != null) return Right(user);
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
  Future<Either<Failure, void>> refreshToken([String? token]) async {
    final tokenToUse = token ?? await _localDataSource.getRefreshToken();
    if (tokenToUse == null) {
      return Left(AuthFailure('No refresh token found'));
    }

    if (await _networkInfo.isConnected) {
      try {
        debugPrint('🌐 [AuthRepository] Refreshing token...');
        final tokens = await _remoteDataSource.refreshToken(tokenToUse);
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

  @override
  Future<Either<Failure, void>> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.changePassword(currentPassword, newPassword);
        // Update credentials for biometrics if they exist
        final user = await _localDataSource.getUser();
        if (user != null) {
          await _localDataSource.saveCredentials(user.email, newPassword);
        }
        return const Right(null);
      } catch (e) {
        return Left(AuthFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteAccount();
        // Clear local data after deletion
        await logout();
        return const Right(null);
      } catch (e) {
        return Left(AuthFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<SessionModel>>> getSessions() async {
    if (await _networkInfo.isConnected) {
      try {
        final sessions = await _remoteDataSource.getSessions();
        return Right(sessions);
      } catch (e) {
        return Left(AuthFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> revokeSession(String sessionId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.revokeSession(sessionId);
        return const Right(null);
      } catch (e) {
        return Left(AuthFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> revokeAllOtherSessions() async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.revokeAllOtherSessions();
        return const Right(null);
      } catch (e) {
        return Left(AuthFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Map<String, String>?> getBiometricCredentials() async {
    return _localDataSource.getCredentials();
  }

  @override
  Future<void> clearBiometricCredentials() async {
    await _localDataSource.clearCredentials();
  }

  @override
  Future<void> logConnection() async {
    if (await _networkInfo.isConnected) {
      try {
        // 1. Get IP and Location info
        String? ip;
        String? country;
        String? city;

        try {
          final response = await http
              .get(Uri.parse('https://ipwho.is/'))
              .timeout(const Duration(seconds: 5));
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            if (data['success'] == true) {
              ip = data['ip'] as String?;
              country = data['country'] as String?;
              city = data['city'] as String?;
            }
          }
        } catch (e) {
          debugPrint('⚠️ [AuthRepository] Failed to fetch IP/Location: $e');
        }

        // 2. Get Device info
        final deviceInfoPlugin = DeviceInfoPlugin();
        String device = 'Unknown Device';
        if (Platform.isAndroid) {
          final androidInfo = await deviceInfoPlugin.androidInfo;
          device = '${androidInfo.manufacturer} ${androidInfo.model}';
        } else if (Platform.isIOS) {
          final iosInfo = await deviceInfoPlugin.iosInfo;
          device = iosInfo.name;
        }

        final request = ConnectionRequest(
          ip: ip,
          country: country,
          city: city,
          device: device,
        );

        await _remoteDataSource.logConnection(request);
      } catch (e) {
        debugPrint('⚠️ [AuthRepository] Failed to log connection: $e');
      }
    }
  }

  @override
  Future<Either<Failure, CountryChangeRequestModel>> requestCountryChange(
    String countryCode,
  ) async {
    if (!await _networkInfo.isConnected) return Left(NetworkFailure());

    try {
      final request = await _remoteDataSource.requestCountryChange(countryCode);
      return Right(request);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateLanguage(String languageCode) async {
    if (!await _networkInfo.isConnected) return Left(NetworkFailure());

    try {
      await _remoteDataSource.updateLanguage(languageCode);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<String?> getLoginProvider() async {
    return _localDataSource.getLoginProvider();
  }

  @override
  Future<void> saveLoginProvider(String provider) async {
    await _localDataSource.saveLoginProvider(provider);
  }

  @override
  Future<String?> getBiometricToken() async {
    return _localDataSource.getBiometricToken();
  }

  @override
  Future<void> saveBiometricToken(String token) async {
    await _localDataSource.saveBiometricToken(token);
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String _generateNonce([int length = 32]) {
    const charset =
        '01234567843363pulq350psuapeh5ed1ckmhaqd6flnniABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  /// Returns the sha256 hash of [input] in hex form.
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
