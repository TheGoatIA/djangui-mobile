import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:logger/logger.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../di/injection.dart';

class KauriAuthenticator extends Authenticator {
  @override
  FutureOr<Request?> authenticate(
    Request request,
    Response response, [
    Request? originalRequest,
  ]) async {
    final logger = getIt<Logger>();
    final String requestUrl = request.url.toString();

    if (response.statusCode == 401) {
      // If we're already trying to refresh or login, don't try again to avoid infinite loops
      if (requestUrl.contains('/auth/refresh') ||
          requestUrl.contains('/auth/login') ||
          requestUrl.contains('/auth/firebase')) {
        logger.w(
          '🔐 [Authenticator] 401 detected on an auth endpoint ($requestUrl). Breaking loop.',
        );
        return null;
      }

      final authRepository = getIt<AuthRepository>();
      final accessToken = await authRepository.getAccessToken();
      final refreshToken = await authRepository.getRefreshToken();

      if (accessToken == null || refreshToken == null) {
        logger.w(
          '🔐 [Authenticator] 401 detected but no tokens found. Probably a guest request or invalid initial state. No logout triggered.',
        );
        return null;
      }

      logger.d(
        '🔐 [Authenticator] 401 Unauthorized detected on $requestUrl. Attempting to refresh token...',
      );

      final result = await authRepository.refreshToken();

      return await result.fold(
        (failure) {
          logger.e(
            '🔐 [Authenticator] Refresh failed: ${failure.message}. Redirecting to login.',
          );
          // Trigger global logout so UI reacts
          getIt<AuthBloc>().add(AuthLogoutRequested());
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

    if (response.statusCode == 429) {
      logger.w(
        '🔐 [Authenticator] 429 Too Many Requests detected on $requestUrl. This is usually triggered by the server or a proxy rate limiter.',
      );
      return null;
    }
    return null;
  }
}
