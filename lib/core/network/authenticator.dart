import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:logger/logger.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../di/injection.dart';

class DjanguiAuthenticator extends Authenticator {
  @override
  FutureOr<Request?> authenticate(
    Request request,
    Response response, [
    Request? originalRequest,
  ]) async {
    final logger = getIt<Logger>();
    if (response.statusCode == 401) {
      logger.d(
        '🔐 [Authenticator] 401 Unauthorized detected. Attempting to refresh token...',
      );

      final authRepository = getIt<AuthRepository>();
      final result = await authRepository.refreshToken();

      return await result.fold(
        (failure) {
          logger.e(
            '🔐 [Authenticator] Refresh failed: ${failure.message}. Redirecting to login.',
          );
          // Logic for logout/redirect could be here or handled by the AuthBloc listening to failures
          return null;
        },
        (_) async {
          logger.d('🔐 [Authenticator] Refresh success! Retrying request...');
          final newToken = await authRepository.getAccessToken();

          if (newToken != null) {
            final headers = Map<String, String>.from(request.headers);
            headers['Authorization'] = 'Bearer $newToken';
            return request.copyWith(headers: headers);
          }
          return null;
        },
      );
    }
    return null;
  }
}
