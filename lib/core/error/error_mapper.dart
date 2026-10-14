import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kauri/di/injection.dart';
import 'package:kauri/l10n/app_localizations.dart';

/// Traduit et nettoie toute exception Dart brute, erreur réseau ou réponse serveur
/// en un message d'erreur clair, sécurisé et compréhensible pour l'utilisateur.
///
/// Garantit qu'aucun détail interne (traces Node.js, JSON brut, pile d'appels,
/// chemins de fichiers, SQL/Prisma, exceptions Dart) n'est jamais exposé à l'utilisateur.
class ErrorMapper {
  ErrorMapper._();

  /// Résout les libellés localisés sans `BuildContext`.
  static AppLocalizations _l10n() {
    String code = 'fr';
    try {
      code = getIt<SharedPreferences>().getString('language_code') ?? 'fr';
    } catch (_) {
      // SharedPreferences pas encore prêt : fallback sur le français
    }
    return lookupAppLocalizations(Locale(code));
  }

  /// Point d'entrée principal : renvoie un message sécurisé, clair et convivial
  /// pour l'utilisateur, à partir d'une erreur ou d'un message backend.
  static String safeMessage(
    Object? error, {
    String? backendMessage,
    int? statusCode,
  }) {
    final l10n = _l10n();

    // 1. Tenter d'extraire et nettoyer le message backend s'il existe
    final candidate = backendMessage ?? error?.toString();
    if (candidate != null && candidate.isNotEmpty && candidate != 'null') {
      final cleaned = cleanMessage(candidate, statusCode: statusCode);
      if (cleaned != null && cleaned.isNotEmpty) {
        return cleaned;
      }
    }

    // 2. Erreurs réseau spécifiques
    if (error != null) {
      if (_isNetworkError(error)) return l10n.networkErrorGeneric;
      if (_isTimeoutError(error)) return l10n.timeoutErrorGeneric;
    }

    // 3. Fallbacks intelligents par code de statut HTTP
    if (statusCode != null) {
      switch (statusCode) {
        case 400:
          return 'Les informations fournies sont invalides ou incomplètes.';
        case 401:
          return 'Votre session a expiré. Veuillez vous reconnecter.';
        case 403:
          return 'Accès refusé. Vous devez valider votre compte ou votre KYC pour effectuer cette action.';
        case 404:
          return 'La ressource demandée est introuvable.';
        case 409:
          return 'Un conflit est survenu avec cette opération.';
        case 422:
          return 'Données non traitables. Veuillez vérifier votre saisie.';
        case 429:
          return 'Trop de tentatives. Veuillez patienter quelques instants.';
        case 500:
        case 502:
        case 503:
        case 504:
          return 'Le serveur rencontre une indisponibilité temporaire. Veuillez réessayer plus tard.';
      }
    }

    return l10n.genericError;
  }

  /// Nettoie en profondeur une chaîne brute pour en extraire uniquement la phrase
  /// humaine compréhensible, sans traces de pile (stack trace) ni JSON brut.
  static String? cleanMessage(String rawInput, {int? statusCode}) {
    var text = rawInput.trim();
    if (text.isEmpty || text == 'null') return null;

    // 1. Si le texte est un objet JSON stringifié (ex: {"message": "...", "stack": "..."}),
    // on extrait le contenu du message et on ignore la stack trace
    if ((text.startsWith('{') && text.endsWith('}')) ||
        (text.startsWith('[') && text.endsWith(']'))) {
      try {
        final decoded = jsonDecode(text);
        if (decoded is Map) {
          final msg = decoded['message'] ?? decoded['error'] ?? decoded['detail'];
          if (msg is String && msg.isNotEmpty) {
            text = msg;
          } else if (msg is List && msg.isNotEmpty) {
            text = msg.map((e) => e.toString()).join(' ');
          }
        }
      } catch (_) {
        // En cas de JSON malformé avec clés non citées, on tente d'extraire via regex
        final match = RegExp(r'message[:\s]+["\x27]?([^"\x27,\}\n]+)["\x27]?').firstMatch(text);
        if (match != null && match.group(1) != null) {
          text = match.group(1)!.trim();
        }
      }
    }

    // 2. Supprimer les traces de pile Node.js / Dart (tout ce qui commence par `\n    at ` ou `at Object.`)
    final lines = text.split('\n');
    final cleanLines = <String>[];
    for (final line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.startsWith('at ') ||
          trimmedLine.contains('node_modules') ||
          trimmedLine.contains('.js:') ||
          trimmedLine.contains('.ts:') ||
          trimmedLine.contains('.dart:') ||
          trimmedLine.startsWith('processTicksAndRejections') ||
          trimmedLine.contains('stack:') ||
          trimmedLine.contains('stacktrace:') ||
          trimmedLine.startsWith('-->') ||
          trimmedLine.startsWith('<--')) {
        break; // On coupe dès que la trace technique commence
      }
      cleanLines.add(line);
    }
    text = cleanLines.join(' ').trim();

    // 3. Supprimer les préfixes d'exceptions techniques courantes
    final prefixesToRemove = [
      'Exception:',
      'Error:',
      'BadRequestException:',
      'ForbiddenException:',
      'UnauthorizedException:',
      'InternalServerErrorException:',
      'HttpException:',
      'ClientException:',
      'ServerFailure:',
      'ValidationException:',
      'AppError:',
    ];
    for (final prefix in prefixesToRemove) {
      if (text.startsWith(prefix)) {
        text = text.substring(prefix.length).trim();
      }
    }

    // 4. Détecter et traduire intelligemment les messages métier / techniques clés
    final lower = text.toLowerCase();

    // --- KYC / Vérification d'identité ---
    if (lower.contains('kyc') ||
        lower.contains('identity verification') ||
        lower.contains('vérification d\'identité') ||
        lower.contains('piece d\'identite') ||
        lower.contains('document verification')) {
      if (lower.contains('pending') || lower.contains('en attente') || lower.contains('en cours')) {
        return 'Votre dossier KYC est en cours de validation. Les retraits seront disponibles dès son approbation.';
      }
      return 'Votre profil KYC n\'a pas encore été validé. Veuillez soumettre ou finaliser vos documents pour débloquer les retraits.';
    }

    // --- Soldes et fonds ---
    if (lower.contains('insufficient_funds') ||
        lower.contains('insufficient balance') ||
        lower.contains('solde insuffisant') ||
        lower.contains('fonds insuffisants') ||
        lower.contains('montant superieur au solde')) {
      return 'Votre solde est insuffisant pour effectuer cette opération.';
    }

    // --- Montants et plafonds ---
    if (lower.contains('minimum amount') ||
        lower.contains('montant minimum') ||
        lower.contains('seuil minimum') ||
        lower.contains('exceeds daily limit') ||
        lower.contains('plafond')) {
      return 'Le montant saisi ne respecte pas les limites ou plafonds autorisés.';
    }

    // --- Téléphone et opérateur de paiement ---
    if (lower.contains('invalid phone') ||
        lower.contains('invalid provider') ||
        lower.contains('numéro de téléphone invalide') ||
        lower.contains('operateur non supporte')) {
      return 'Le numéro de téléphone ou l\'opérateur sélectionné est invalide. Veuillez vérifier votre saisie.';
    }

    // --- Authentification / Sessions ---
    if (lower.contains('jwt expired') ||
        lower.contains('token expired') ||
        lower.contains('session expired') ||
        lower.contains('unauthorized') ||
        lower.contains('jeton invalide')) {
      return 'Votre session a expiré. Veuillez vous reconnecter.';
    }

    // --- Erreurs de base de données / crash serveur Node.js ---
    if (lower.contains('cannot read propert') ||
        lower.contains('undefined is not') ||
        lower.contains('prisma') ||
        lower.contains('sequelize') ||
        lower.contains('econnrefused') ||
        lower.contains('query failed') ||
        lower.contains('sql') ||
        lower.contains('null check operator') ||
        lower.contains('type \'null\'') ||
        lower.contains('internal server error')) {
      return 'Une erreur technique temporaire est survenue sur nos serveurs. Veuillez réessayer dans un instant.';
    }

    // 5. Si après nettoyage le message ressemble à une phrase claire et lisible
    if (_looksLikeUserMessage(text)) {
      // Nettoyer d'éventuels guillemets superflus
      if ((text.startsWith('"') && text.endsWith('"')) ||
          (text.startsWith("'") && text.endsWith("'"))) {
        text = text.substring(1, text.length - 1).trim();
      }
      return text;
    }

    // 6. Si le message reste trop cryptique ou long, utiliser le fallback
    return null;
  }

  /// Vérifie si la chaîne est un message compréhensible pour un utilisateur.
  static bool _looksLikeUserMessage(String message) {
    final trimmed = message.trim();
    if (trimmed.isEmpty || trimmed.length > 250) return false;

    // Doit contenir au moins un espace ou être un mot court propre
    if (!trimmed.contains(' ') && trimmed.length > 30) return false;

    // Pas de balises HTML
    if (trimmed.contains('<html') || trimmed.contains('<!doctype') || trimmed.contains('</div>')) {
      return false;
    }

    final lower = trimmed.toLowerCase();
    const technicalMarkers = [
      'stacktrace',
      'stack trace',
      'formatexception',
      'socketexception',
      'handshakeexception',
      'clientexception',
      '.dart:',
      'at object.',
      'errno',
      'jsonobject',
      'syntaxerror',
      'typeerror',
      'referenceerror',
      'node_modules',
      'prismaclient',
      'unhandled rejection',
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
