import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../di/injection.dart';

class AuthInterceptor implements RequestInterceptor {
  final FlutterSecureStorage _storage = getIt<FlutterSecureStorage>();

  @override
  FutureOr<Request> onRequest(Request request) async {
    // Endpoints that don't need the Authorization header
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

    final String? token = await _storage.read(key: 'access_token');

    if (token != null) {
      final headers = Map<String, String>.from(request.headers);
      headers['Authorization'] = 'Bearer $token';
      return request.copyWith(headers: headers);
    }
    return request;
  }
}

class HttpLoggingInterceptor
    implements RequestInterceptor, ResponseInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) async {
    if (kDebugMode) {
      print('🌐 REQUEST: ${request.method} ${request.url}');
      print('📦 Headers: ${request.headers}');
      if (request.body != null) print('📦 Body: ${request.body}');
    }
    return request;
  }

  @override
  FutureOr<Response> onResponse(Response response) async {
    if (kDebugMode) {
      print('✅ RESPONSE: ${response.statusCode} ${response.base.request?.url}');
      if (response.bodyString.isNotEmpty) {
        print('📥 Body: ${response.bodyString}');
      }
      if (response.error != null) {
        print('❌ Error: ${response.error}');
      }
    }
    return response;
  }
}
