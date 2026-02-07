import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/analytics_repository.dart';
import 'package:kauri/features/analytics/data/models/analytics_models.dart';
import 'package:kauri/core/services/log_service.dart';
import 'package:kauri/di/injection.dart';

@lazySingleton
class AnalyticsManager {
  final AnalyticsRepository _repository;
  final SharedPreferences _prefs;

  String? _sessionId;
  String? _deviceId;
  String? _platform;
  String? _appVersion;

  static const String _kSessionKey = 'analytics_session_id';

  AnalyticsManager(this._repository, this._prefs);

  Future<void> initialize() async {
    final packageInfo = await PackageInfo.fromPlatform();
    _appVersion = packageInfo.version;

    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      _deviceId = androidInfo.id;
      _platform = 'android';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      _deviceId = iosInfo.identifierForVendor;
      _platform = 'ios';
    } else if (kIsWeb) {
      final webInfo = await deviceInfo.webBrowserInfo;
      _deviceId = webInfo.userAgent;
      _platform = 'web';
    }

    _sessionId = _prefs.getString(_kSessionKey);

    if (_sessionId == null) {
      await startNewSession();
    }
  }

  Future<void> startNewSession() async {
    final result = await _repository.startSession(
      deviceId: _deviceId,
      platform: _platform,
      appVersion: _appVersion,
    );

    result.fold(
      (failure) {
        debugPrint('❌ [Analytics] Failed to start session: $failure');
        getIt<LogService>().error(
          'Failed to start session',
          component: 'AnalyticsManager',
          error: failure,
        );
      },
      (sessionId) {
        _sessionId = sessionId;
        _prefs.setString(_kSessionKey, sessionId);
        debugPrint('✅ [Analytics] Session started: $_sessionId');
      },
    );
  }

  Future<void> endCurrentSession() async {
    if (_sessionId != null) {
      final result = await _repository.endSession(_sessionId!);
      result.fold(
        (failure) {
          debugPrint('❌ [Analytics] Failed to end session: $failure');
          getIt<LogService>().error(
            'Failed to end session',
            component: 'AnalyticsManager',
            error: failure,
          );
        },
        (_) {
          debugPrint('✅ [Analytics] Session ended: $_sessionId');
          _sessionId = null;
          _prefs.remove(_kSessionKey);
        },
      );
    }
  }

  Future<void> trackEvent({
    required String feature,
    required String action,
    Map<String, dynamic>? details,
  }) async {
    final activity = UserActivity(
      feature: feature,
      action: action,
      details: details,
      platform: _platform,
      appVersion: _appVersion,
    );

    final result = await _repository.trackEvent(activity);
    result.fold((failure) {
      debugPrint('❌ [Analytics] Failed to track event: $failure');
      // Optional: Log tracking failure to Graylog if critical, but might be noisy.
      // getIt<LogService>().warning('Failed to track event', component: 'AnalyticsManager', error: failure);
    }, (_) => debugPrint('📊 [Analytics] Event tracked: $feature - $action'));
  }
}
