import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

    final bool isExcluded = excludedPaths.any(
      (path) => request.url.toString().contains(path),
    );

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
