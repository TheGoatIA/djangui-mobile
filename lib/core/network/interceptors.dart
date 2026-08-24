import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kauri/core/services/log_service.dart';
import 'package:uuid/uuid.dart';
import '../../di/injection.dart';

/// Endpoints whose request/response bodies must never be logged (locally or
/// remotely) — they carry credentials, financial records, payment tokens, or PII.
bool _isBodySensitive(Uri url) {
  final path = url.path.toLowerCase();
  return path.contains('/auth/') ||
      path.contains('/fintech/') ||
      path.contains('/payments/') ||
      path.contains('/transactions/') ||
      path.contains('/reseller/') ||
      path.contains('/vault');
}

/// Fragments d'URL correspondant aux routes financières protégées côté
/// serveur par le middleware de déduplication Idempotency-Key (voir
/// djangui-api/src/middleware/idempotency.ts). Matché par simple inclusion
/// pour couvrir les segments templatés (ex: /goals/{id}/contribute).
const _idempotencyProtectedPathFragments = [
  '/payout/withdraw',
  '/challenge/deposit',
  '/contribute', // /goals/{id}/contribute ET /tontines/contribute
  '/redeem', // /goals/{id}/redeem ET /challenges/{id}/redeem
  '/validate-week',
  '/checkout/stripe',
  '/init/notchpay',
  '/pay/wallet',
];

/// Attache une clé `Idempotency-Key` unique aux requêtes mutant de l'argent
/// réel (K-10), pour activer la déduplication déjà implémentée côté serveur.
///
/// Une nouvelle clé est générée par requête sortante, sauf si l'appelant en a
/// déjà fourni une explicitement (ex: rejeu d'une action mise en file
/// d'attente hors-ligne, qui doit réutiliser la MÊME clé à chaque tentative
/// — voir K-17 et le champ `idempotencyKey` du payload dans `SyncRequests`).
class IdempotencyKeyInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    var request = chain.request;

    if (request.method == 'POST' &&
        !request.headers.containsKey('Idempotency-Key') &&
        _idempotencyProtectedPathFragments.any(request.url.path.contains)) {
      final headers = Map<String, String>.from(request.headers);
      headers['Idempotency-Key'] = const Uuid().v4();
      request = request.copyWith(headers: headers);
    }

    return chain.proceed(request);
  }
}

/// Intercepteur chargé d'ajouter automatiquement le jeton d'authentification aux requêtes sortantes.
class AuthInterceptor implements Interceptor {
  final FlutterSecureStorage _storage = getIt<FlutterSecureStorage>();

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    var request = chain.request;
    // Liste des chemins qui ne nécessitent pas de jeton d'authentification (connexion, inscription, etc.)
    final List<String> excludedPaths = [
      '/auth/login',
      '/auth/register',
      '/auth/refresh',
      '/auth/forgot-password',
      '/auth/reset-password',
      '/auth/verify-email',
      '/auth/firebase',
      '/system/public-settings',
      '/system/countries',
      '/system/version-check',
      '/config/features',
    ];

    final bool isExcluded = excludedPaths.any((path) {
      final uri = request.url;
      return uri.path.endsWith(path);
    });

    if (!isExcluded) {
      // Tentative de lecture du jeton d'accès depuis le stockage sécurisé
      final String? token = await _storage.read(key: 'access_token');

      if (token != null) {
        final headers = Map<String, String>.from(request.headers);
        headers['Authorization'] = 'Bearer $token';
        request = request.copyWith(headers: headers);
      }
    }

    return chain.proceed(request);
  }
}

/// Intercepteur de journalisation pour déboguer les échanges HTTP en mode développement.
class HttpLoggingInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final request = chain.request;
    final sensitive = _isBodySensitive(request.url);
    if (kDebugMode) {
      debugPrint('🌐 REQUÊTE : ${request.method} ${request.url}');
      final safeHeaders = Map<String, String>.from(request.headers);
      if (safeHeaders.containsKey('Authorization')) {
        safeHeaders['Authorization'] = 'Bearer [redacted]';
      }
      debugPrint('📦 En-têtes : $safeHeaders');
      if (request.body != null) {
        debugPrint(sensitive ? '📦 Corps : [redacted]' : '📦 Corps : ${request.body}');
      }
    }

    final response = await chain.proceed(request);

    if (kDebugMode) {
      debugPrint(
        '✅ RÉPONSE : ${response.statusCode} ${response.base.request?.url}',
      );
      if (response.bodyString.isNotEmpty) {
        debugPrint(sensitive ? '📥 Corps : [redacted]' : '📥 Corps : ${response.bodyString}');
      }
      if (response.error != null) {
        debugPrint('❌ Erreur : ${response.error}');
      }
    }
    return response;
  }
}

/// Intercepteur qui envoie les métadonnées des requêtes HTTP vers Graylog.
class RemoteLoggingInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final request = chain.request;
    // Éviter de logger l'envoi des logs eux-mêmes pour éviter une boucle infinie
    if (request.url.toString().contains('/system/telemetry/logs')) {
      return chain.proceed(request);
    }

    getIt<LogService>().info(
      '🌐 API Request: ${request.method} ${request.url.path}',
      component: 'Network',
      metadata: {
        'method': request.method,
        'url': request.url.toString(),
        'has_body': request.body != null,
      },
    );

    final response = await chain.proceed(request);

    final isError = response.statusCode >= 400;
    final message =
        '📥 API Response: ${response.statusCode} ${response.base.request?.url.path}';
    final sensitive = _isBodySensitive(request.url);

    if (isError) {
      getIt<LogService>().error(
        message,
        component: 'Network',
        metadata: {
          'status_code': response.statusCode,
          'url': response.base.request?.url.toString(),
          'error': response.error?.toString(),
          'body': sensitive ? '[redacted]' : response.bodyString,
        },
      );
    } else {
      getIt<LogService>().info(
        message,
        component: 'Network',
        metadata: {
          'status_code': response.statusCode,
          'url': response.base.request?.url.toString(),
        },
      );
    }
    return response;
  }
}
