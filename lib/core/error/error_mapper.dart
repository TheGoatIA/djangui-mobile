import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kauri/di/injection.dart';
import 'package:kauri/l10n/app_localizations.dart';

/// Traduit une exception Dart brute (réseau, timeout, parsing, erreur
/// inconnue...) en un message d'erreur sûr et compréhensible pour
/// l'utilisateur, dans la langue courante de l'app — jamais le texte brut
/// d'une exception technique (`e.toString()`), qui peut exposer des détails
/// internes (type d'exception Dart, hôte réseau, chemin de fichier, trace).
///
/// À utiliser dans chaque `catch (e)` de couche repository/datasource, à la
/// place de `XFailure(e.toString())` :
///
/// ```dart
/// catch (e) {
///   return Left(ServerFailure(ErrorMapper.safeMessage(e)));
/// }
/// ```
///
/// Si le backend a déjà renvoyé un message métier propre et pensé pour
/// l'utilisateur (ex: une `AppError` du serveur comme "Cette tontine est
/// suspendue..."), passez-le via [backendMessage] : il est conservé tel quel
/// tant qu'il ne ressemble pas à une trace technique (voir [_looksLikeUserMessage]).
class ErrorMapper {
  ErrorMapper._();

  /// Résout les libellés localisés sans `BuildContext` (le code de repository
  /// n'a pas accès à l'arbre de widgets), en lisant la langue choisie par
  /// l'utilisateur directement depuis les préférences (clé `language_code`,
  /// la même source de vérité que [SettingsBloc]).
  static AppLocalizations _l10n() {
    String code = 'fr';
    try {
      code = getIt<SharedPreferences>().getString('language_code') ?? 'fr';
    } catch (_) {
      // SharedPreferences pas encore prêt (ex: erreur très tôt au démarrage) :
      // on retombe sur le français par défaut plutôt que de faire planter
      // l'affichage de l'erreur elle-même.
    }
    return lookupAppLocalizations(Locale(code));
  }

  /// Point d'entrée principal : renvoie un message sûr à afficher pour
  /// l'exception [error], en préférant [backendMessage] quand il constitue
  /// déjà un message utilisateur propre.
  static String safeMessage(Object error, {String? backendMessage}) {
    final l10n = _l10n();

    if (backendMessage != null && _looksLikeUserMessage(backendMessage)) {
      return backendMessage;
    }

    if (_isNetworkError(error)) return l10n.networkErrorGeneric;
    if (_isTimeoutError(error)) return l10n.timeoutErrorGeneric;

    return l10n.genericError;
  }

  /// Un message backend est affiché tel quel seulement s'il ressemble à une
  /// phrase pensée pour un humain, pas à une trace technique.
  static bool _looksLikeUserMessage(String message) {
    final trimmed = message.trim();
    if (trimmed.isEmpty || trimmed.length > 200) return false;

    final lower = trimmed.toLowerCase();
    const technicalMarkers = [
      'exception',
      'stacktrace',
      'stack trace',
      'null check operator',
      "type '",
      'formatexception',
      'socketexception',
      'handshakeexception',
      'clientexception',
      'internal server error',
      '.dart:',
      'at object.',
      'errno',
    ];
    if (technicalMarkers.any(lower.contains)) return false;

    return true;
  }

  static bool _isNetworkError(Object error) {
    final s = error.toString().toLowerCase();
    return s.contains('socketexception') ||
        s.contains('clientexception') ||
        s.contains('failed host lookup') ||
        s.contains('connection refused') ||
        s.contains('connection closed') ||
        s.contains('network is unreachable') ||
        s.contains('no address associated with hostname');
  }

  static bool _isTimeoutError(Object error) {
    final s = error.toString().toLowerCase();
    return s.contains('timeoutexception') || s.contains('timeout');
  }
}
