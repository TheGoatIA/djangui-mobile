import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';

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
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
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
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      await _localDataSource.saveUser(response.user);
      return Right(response);
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
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
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
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
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
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _localDataSource.clearTokens();
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
}
