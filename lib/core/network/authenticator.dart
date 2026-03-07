import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:logger/logger.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../di/injection.dart';

/// Gère les mécanismes d'authentification automatique lors d'échecs de requêtes (Code 401).
///
/// Principalement utilisé pour rafraîchir le jeton d'accès (Refresh Token) sans
/// intervention de l'utilisateur.
class KauriAuthenticator extends Authenticator {
  @override
  FutureOr<Request?> authenticate(
    Request request,
    Response response, [
    Request? originalRequest,
  ]) async {
    final logger = getIt<Logger>();
    final String requestUrl = request.url.toString();

    // Traitement des erreurs 401 (Non autorisé)
    if (response.statusCode == 401) {
      // Évite les boucles infinies si les appels d'authentification eux-mêmes échouent
      if (requestUrl.contains('/auth/refresh') ||
          requestUrl.contains('/auth/login') ||
          requestUrl.contains('/auth/firebase')) {
        logger.w(
          '🔐 [Authenticator] 401 détecté sur un endpoint d\'auth ($requestUrl). Arrêt du processus.',
        );
        return null;
      }

      final authRepository = getIt<AuthRepository>();
      final accessToken = await authRepository.getAccessToken();
      final refreshToken = await authRepository.getRefreshToken();

      // Si aucun jeton n'est présent, on ne peut rien rafraîchir
      if (accessToken == null || refreshToken == null) {
        logger.w(
          '🔐 [Authenticator] 401 détecté mais aucun jeton trouvé. Probablement une requête invitée ou un état invalide.',
        );
        return null;
      }

      logger.d(
        '🔐 [Authenticator] 401 Unauthorized sur $requestUrl. Tentative de rafraîchissement du token...',
      );

      // Tentative de récupération d'un nouveau couple de jetons
      final result = await authRepository.refreshToken();

      return await result.fold(
        (failure) {
          logger.e(
            '🔐 [Authenticator] Échec du rafraîchissement: ${failure.message}. Redirection vers la page de connexion.',
          );
          // Déclenche une déconnexion globale pour que l'interface réagisse (UI)
          getIt<AuthBloc>().add(AuthLogoutRequested());
          return null;
        },
        (_) async {
          logger.d(
            '🔐 [Authenticator] Rafraîchissement réussi ! Relance de la requête originale...',
          );
          final newToken = await authRepository.getAccessToken();

          if (newToken != null) {
            // Recrée la requête avec le nouveau jeton dans les en-têtes
            final headers = Map<String, String>.from(request.headers);
            headers['Authorization'] = 'Bearer $newToken';
            return request.copyWith(headers: headers);
          }
          return null;
        },
      );
    }

    // Traitement spécifique pour la limitation de débit (Rate Limiting)
    if (response.statusCode == 429) {
      logger.w(
        '🔐 [Authenticator] 429 Too Many Requests détecté sur $requestUrl.',
      );
      return null;
    }

    // Traitement pour les suspensions (403 Forbidden - Security Policy)
    if (response.statusCode == 403) {
      logger.e(
        '🔐 [Authenticator] 403 Forbidden détecté sur $requestUrl. Suspension probable.',
      );
      // On peut ajouter un événement spécifique au bloc pour afficher une popup bloquante
      getIt<AuthBloc>().add(AuthAccountSuspended());
      return null;
    }

    return null;
  }
}
