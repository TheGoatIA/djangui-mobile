import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/auth_response.dart';
import '../../data/models/user_model.dart';
import '../../data/models/login_request.dart';
import '../../data/models/register_request.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponse>> login(LoginRequest request);
  Future<Either<Failure, AuthResponse>> signInWithGoogle();
  Future<Either<Failure, void>> verifyPhoneNumber(
    String phoneNumber, {
    required Function(String verificationId) onCodeSent,
    required Function(String errorMessage) onVerificationFailed,
  });
  Future<Either<Failure, AuthResponse>> signInWithPhoneNumber(
    String verificationId,
    String smsCode,
  );
  Future<Either<Failure, void>> linkPhoneNumber(
    String verificationId,
    String smsCode,
  );
  Future<Either<Failure, AuthResponse>> register(RegisterRequest request);
  Future<Either<Failure, void>> logout();
  Future<bool> isAuthenticated();
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<Either<Failure, UserModel>> getCurrentUser();
  Future<Either<Failure, UserModel>> updateProfile({
    String? firstName,
    String? lastName,
    String? country,
    String? avatar,
  });
  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, void>> resetPassword(String token, String newPassword);
  Future<Either<Failure, void>> verifyEmail(String token);
  Future<Either<Failure, void>> refreshToken();
  Future<Either<Failure, void>> updateFcmToken(String token);
}
