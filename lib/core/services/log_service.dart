import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:kauri/core/config/env_config.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';

enum LogLevel { info, warning, error, debug }

@lazySingleton
class LogService {
  final http.Client _client = http.Client();
  late final String _endpoint;

  Map<String, dynamic> _deviceMetadata = {};

  LogService() {
    _endpoint = EnvConfig.apiLogsEndpoint;
    _initMetadata();
  }

  Future<void> _initMetadata() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final deviceInfo = DeviceInfoPlugin();

      String os = 'unknown';
      String model = 'unknown';

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        os = 'Android ${androidInfo.version.release}';
        model = androidInfo.model;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        os = 'iOS ${iosInfo.systemVersion}';
        model = iosInfo.utsname.machine;
      }

      _deviceMetadata = {
        'app_version': packageInfo.version,
        'app_build': packageInfo.buildNumber,
        'os': os,
        'device_model': model,
        'platform': Platform.operatingSystem,
      };
    } catch (e) {
      debugPrint('⚠️ [LogService] Failed to init metadata: $e');
    }
  }

  String? _userId;

  void setUserId(String? userId) {
    if (userId == null || userId.isEmpty) {
      _userId = null;
    } else {
      // Hachage SHA-256 systématique de l'ID utilisateur (K-30)
      _userId = sha256.convert(utf8.encode(userId)).toString();
    }
  }

  /// Sends a log to the remote Graylog collector
  Future<void> log({
    required LogLevel level,
    required String message,
    Map<String, dynamic>? metadata,
    String? component,
    String? page,
  }) async {
    // In development: log to console
    if (kDebugMode) {
      debugPrint('[${level.name.toUpperCase()}] $message | Meta: $metadata');
    }

    if (_endpoint.isEmpty) return;

    // En production, ne remonter à distance que les warnings et erreurs critiques (K-07)
    if (kReleaseMode && (level == LogLevel.debug || level == LogLevel.info)) {
      return;
    }

    try {
      final traceId = const Uuid().v4();

      final payload = {
        'level': level.name,
        'message': message,
        'metadata': {
          ..._deviceMetadata,
          'trace_id': traceId,
          if (_userId != null) 'user_id': _userId,
          if (metadata != null) ...metadata,
          if (component != null) 'component': component,
          if (page != null) 'page': page,
          'timestamp': DateTime.now().toIso8601String(),
        },
      };

      // Ne jamais transmettre le Bearer token dans les en-têtes de télémétrie/logs (K-07)
      final headers = {
        'Content-Type': 'application/json',
        'X-Trace-Id': traceId,
      };

      // Fire and forget to not block UI, but with error handling
      _client
          .post(
            Uri.parse(_endpoint),
            headers: headers,
            body: jsonEncode(payload),
          )
          .then((response) {
            if (response.statusCode >= 400 && kDebugMode) {
              debugPrint(
                '❌ [LogService] Failed to send log (${response.statusCode}): ${response.body}',
              );
            }
          })
          .catchError((e) {
            if (kDebugMode) {
              debugPrint('❌ [LogService] Network error sending log: $e');
            }
          });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ [LogService] Error preparing log: $e');
      }
    }
  }

  void info(
    String message, {
    Map<String, dynamic>? metadata,
    String? component,
    String? page,
  }) => log(
    level: LogLevel.info,
    message: message,
    metadata: metadata,
    component: component,
    page: page,
  );

  void warning(
    String message, {
    Map<String, dynamic>? metadata,
    String? component,
    String? page,
  }) => log(
    level: LogLevel.warning,
    message: message,
    metadata: metadata,
    component: component,
    page: page,
  );

  void error(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
    String? component,
    String? page,
  }) {
    final meta = {
      if (metadata != null) ...metadata,
      if (error != null) 'error': error.toString(),
      if (stackTrace != null) 'stacktrace': stackTrace.toString(),
    };
    log(
      level: LogLevel.error,
      message: message,
      metadata: meta,
      component: component,
      page: page,
    );
  }

  void debug(
    String message, {
    Map<String, dynamic>? metadata,
    String? component,
    String? page,
  }) => log(
    level: LogLevel.debug,
    message: message,
    metadata: metadata,
    component: component,
    page: page,
  );
}
