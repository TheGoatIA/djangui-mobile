import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kauri/core/services/log_service.dart';
import '../../di/injection.dart';

/// Intercepteur chargé d'ajouter automatiquement le jeton d'authentification aux requêtes sortantes.
class AuthInterceptor implements RequestInterceptor {
  final FlutterSecureStorage _storage = getIt<FlutterSecureStorage>();

  @override
  FutureOr<Request> onRequest(Request request) async {
    // Liste des chemins qui ne nécessitent pas de jeton d'authentification (connexion, inscription, etc.)
    final List<String> excludedPaths = [
      '/auth/login',
      '/auth/register',
      '/auth/refresh',
      '/auth/forgot-password',
      '/auth/reset-password',
      '/auth/verify-email',
      '/auth/firebase',
    ];

    final bool isExcluded = excludedPaths.any((path) {
      final uri = Uri.parse(request.url.toString());
      return uri.path.endsWith(path);
    });

    if (isExcluded) return request;

    // Tentative de lecture du jeton d'accès depuis le stockage sécurisé
    final String? token = await _storage.read(key: 'access_token');

    if (token != null) {
      final headers = Map<String, String>.from(request.headers);
      headers['Authorization'] = 'Bearer $token';
      return request.copyWith(headers: headers);
    }
    return request;
  }
}

/// Intercepteur de journalisation pour déboguer les échanges HTTP en mode développement.
class HttpLoggingInterceptor
    implements RequestInterceptor, ResponseInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) async {
    if (kDebugMode) {
      debugPrint('🌐 REQUÊTE : ${request.method} ${request.url}');
      debugPrint('📦 En-têtes : ${request.headers}');
      if (request.body != null) debugPrint('📦 Corps : ${request.body}');
    }
    return request;
  }

  @override
  FutureOr<Response> onResponse(Response response) async {
    if (kDebugMode) {
      debugPrint(
        '✅ RÉPONSE : ${response.statusCode} ${response.base.request?.url}',
      );
      if (response.bodyString.isNotEmpty) {
        debugPrint('📥 Corps : ${response.bodyString}');
      }
      if (response.error != null) {
        debugPrint('❌ Erreur : ${response.error}');
      }
    }
    return response;
  }
}

/// Intercepteur qui envoie les métadonnées des requêtes HTTP vers Graylog.
class RemoteLoggingInterceptor
    implements RequestInterceptor, ResponseInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) async {
    // Éviter de logger l'envoi des logs eux-mêmes pour éviter une boucle infinie
    if (request.url.toString().contains('/system/telemetry/logs')) {
      return request;
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
    return request;
  }

  @override
  FutureOr<Response> onResponse(Response response) async {
    if (response.base.request?.url.toString().contains(
          '/system/telemetry/logs',
        ) ??
        false) {
      return response;
    }

    final isError = response.statusCode >= 400;
    final message =
        '📥 API Response: ${response.statusCode} ${response.base.request?.url.path}';

    if (isError) {
      getIt<LogService>().error(
        message,
        component: 'Network',
        metadata: {
          'status_code': response.statusCode,
          'url': response.base.request?.url.toString(),
          'error': response.error?.toString(),
          'body': response.bodyString,
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
