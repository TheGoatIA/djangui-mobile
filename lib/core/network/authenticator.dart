import 'dart:async';
import 'dart:convert';
import 'package:chopper/chopper.dart';
import 'package:logger/logger.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../di/injection.dart';

/// Gere les mecanismes d'authentification automatique lors d'echecs de requetes (Code 401).
///
/// Principalement utilise pour rafraichir le jeton d'acces (Refresh Token) sans
/// intervention de l'utilisateur.
///
/// SECURITE: Un `Completer<void>` statique serialise les refreshes concurrents.
/// Sans ce mecanisme, plusieurs requetes simultanees echouant avec 401 declenchaient
/// plusieurs refreshes en parallele, invalidant le refresh token par rotation et
/// causant un logout intempestif (race condition).
class KauriAuthenticator extends Authenticator {
  /// Mutex: si non-null, un refresh est en cours. Les autres requetes 401 attendent.
  static Completer<void>? _refreshCompleter;

  @override
  FutureOr<Request?> authenticate(
    Request request,
    Response response, [
    Request? originalRequest,
  ]) async {
    final logger = getIt<Logger>();
    final String requestUrl = request.url.toString();

    // Traitement des erreurs 401 (Non autorise)
    if (response.statusCode == 401) {
      // Evite les boucles infinies si les appels d'authentification eux-memes echouent
      if (requestUrl.contains('/auth/refresh') ||
          requestUrl.contains('/auth/login') ||
          requestUrl.contains('/auth/logout') ||
          requestUrl.contains('/auth/register') ||
          requestUrl.contains('/auth/firebase') ||
          requestUrl.contains('/auth/forgot-password') ||
          requestUrl.contains('/auth/reset-password')) {
        logger.w(
          '[Authenticator] 401 detecte sur un endpoint d\'auth ($requestUrl). Arret du processus.',
        );
        return null;
      }

      final authRepository = getIt<AuthRepository>();
      final accessToken = await authRepository.getAccessToken();
      final refreshToken = await authRepository.getRefreshToken();

      // Si aucun jeton n'est present, on ne peut rien rafraichir
      if (accessToken == null || refreshToken == null) {
        logger.w(
          '[Authenticator] 401 detecte mais aucun jeton trouve. Probablement une requete invitee.',
        );
        return null;
      }

      // --- MUTEX: Serialisation des refreshes concurrents ---
      // Si un refresh est deja en cours sur une autre requete simultanee,
      // on attend sa completion et on reessaie avec le nouveau token.
      if (_refreshCompleter != null) {
        logger.d(
          '[Authenticator] Refresh deja en cours. Attente de la completion...',
        );
        try {
          await _refreshCompleter!.future;
        } catch (_) {
          // Le refresh precedent a echoue — logout deja declenche par l'autre requete
          return null;
        }
        // Re-tenter avec le nouveau token
        final newToken = await authRepository.getAccessToken();
        if (newToken != null) {
          final headers = Map<String, String>.from(request.headers);
          headers['Authorization'] = 'Bearer $newToken';
          return request.copyWith(headers: headers);
        }
        return null;
      }

      // On est le premier: on prend le verrou
      _refreshCompleter = Completer<void>();
      // Empeche une "Unhandled exception" au niveau de la Zone si aucune
      // requete concurrente n'ecoute ce Future au moment de l'echec:
      // l'erreur reste correctement propagee aux vrais listeners ci-dessous.
      unawaited(_refreshCompleter!.future.catchError((_) {}));

      logger.d(
        '[Authenticator] 401 Unauthorized sur $requestUrl. Tentative de rafraichissement du token...',
      );

      try {
        final result = await authRepository.refreshToken();

        return await result.fold(
          (failure) {
            logger.e(
              '[Authenticator] Echec du rafraichissement: ${failure.message}. Redirection vers la page de connexion.',
            );
            // IMPORTANT: completeError (pas complete) — les requetes concurrentes
            // en attente sur ce mutex doivent abandonner immediatement plutot que
            // de retenter avec l'ancien token (deja invalide), ce qui les ferait
            // echouer a nouveau en silence.
            if (!(_refreshCompleter?.isCompleted ?? true)) {
              _refreshCompleter!.completeError(failure);
            }
            // Declenche une deconnexion globale pour que l'interface reagisse (UI)
            getIt<AuthBloc>().add(AuthLogoutRequested());
            return null;
          },
          (_) async {
            logger.d(
              '[Authenticator] Rafraichissement reussi ! Relance de la requete originale...',
            );
            if (!(_refreshCompleter?.isCompleted ?? true)) {
              _refreshCompleter!.complete();
            }
            final newToken = await authRepository.getAccessToken();

            if (newToken != null) {
              // Recree la requete avec le nouveau jeton dans les en-tetes
              final headers = Map<String, String>.from(request.headers);
              headers['Authorization'] = 'Bearer $newToken';
              return request.copyWith(headers: headers);
            }
            return null;
          },
        );
      } finally {
        // Toujours liberer le verrou, meme en cas d'exception inattendue
        if (!(_refreshCompleter?.isCompleted ?? true)) {
          _refreshCompleter!.complete();
        }
        _refreshCompleter = null;
      }
    }

    // Traitement specifique pour la limitation de debit (Rate Limiting)
    if (response.statusCode == 429) {
      logger.w(
        '[Authenticator] 429 Too Many Requests detecte sur $requestUrl.',
      );
      return null;
    }

    // Traitement pour les suspensions (403 Forbidden - Security Policy).
    // Un 403 seul ne veut pas dire "compte suspendu" : c'est aussi le code
    // renvoye par premiumOnly ("cette fonctionnalite est reservee aux
    // membres Premium") et par restrictTo (acces reserve a un role). Sans
    // distinction, un simple mur Premium declenchait a tort l'ecran bloquant
    // "compte suspendu, contactez le support" — on ne verifie donc que le
    // code d'erreur explicite ACCOUNT_DEACTIVATED pose par protect() cote
    // backend pour une vraie desactivation de compte.
    if (response.statusCode == 403) {
      String? code;
      try {
        final body = response.body;
        final decoded = body is String ? jsonDecode(body) : body;
        if (decoded is Map) code = decoded['code'] as String?;
      } catch (_) {
        // Corps non-JSON ou vide — on traite prudemment comme "pas une
        // suspension de compte" plutot que d'escalader par defaut.
      }

      if (code == 'ACCOUNT_DEACTIVATED') {
        logger.e(
          '[Authenticator] Compte desactive detecte sur $requestUrl.',
        );
        getIt<AuthBloc>().add(AuthAccountSuspended());
      } else {
        logger.w(
          '[Authenticator] 403 Forbidden sur $requestUrl (acces refuse a cette ressource, pas une suspension de compte).',
        );
      }
      return null;
    }

    return null;
  }
}
