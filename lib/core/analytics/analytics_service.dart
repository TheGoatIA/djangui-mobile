import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import '../services/telemetry_service.dart';
import '../services/log_service.dart';
import 'events.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Interface abstraite
// ─────────────────────────────────────────────────────────────────────────────

/// Service centralisé pour toute l'instrumentation analytique de l'application.
///
/// TOUTES les métriques passent par ce service — jamais d'appels directs à
/// Firebase / OpenTelemetry dans les widgets ou BLoCs.
///
/// Règles de confidentialité appliquées ici :
///   ❌ Aucun montant exact — uniquement [AnalyticsAmountRange]
///   ❌ Aucun numéro de téléphone / compte / email
///   ❌ Aucun nom d'utilisateur ou de bénéficiaire
///   ✅ user_id toujours hashé SHA-256
abstract class AnalyticsService {
  /// Enregistre un événement nommé avec des paramètres optionnels.
  Future<void> logEvent(String name, {Map<String, Object?>? parameters});

  /// Définit une propriété utilisateur (valeur anonymisée).
  Future<void> setUserProperty(String name, String value);

  /// Définit l'identifiant utilisateur hashé SHA-256.
  Future<void> setUserId(String? userId);

  /// Démarre une trace Firebase Performance pour mesurer une opération critique.
  ///
  /// Exemple :
  /// ```dart
  /// final stop = await analyticsService.startTrace(PerformanceTraces.transactionE2E);
  /// // ... opération
  /// await stop(status: 'success');
  /// ```
  Future<Future<void> Function({String? status, String? errorType})> startTrace(
    String traceName,
  );

  /// Wrapper pratique pour les opérations avec trace de performance.
  Future<T> withPerformanceTrace<T>(
    String traceName,
    Future<T> Function() operation,
  );

  /// Enrichit les futurs crash reports Crashlytics avec les clés contextuelles.
  void setCrashlyticsContext({
    String? screenName,
    String? lastAction,
    String? appState,
    String? networkState,
    String? walletState,
    String? blocState,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Implémentation principale (wrapping TelemetryService + Firebase)
// ─────────────────────────────────────────────────────────────────────────────

/// Implémentation concrète utilisant OpenTelemetry (TelemetryService) comme
/// backend principal et Firebase Crashlytics/Performance pour l'observabilité
/// production.
///
/// Enregistrée manuellement dans [injection.dart] pour éviter la dépendance
/// à `build_runner`. Si firebase_analytics est ajouté au projet, étendre cette
/// classe pour y déléguer les appels [logEvent].
class KauriAnalyticsService implements AnalyticsService {
  final TelemetryService _telemetry;
  final LogService _logger;

  /// Clés considérées comme sensibles — filtrées avant tout envoi.
  static const _sensitiveKeys = {
    'amount',
    'balance',
    'account_number',
    'phone',
    'phone_number',
    'name',
    'email',
    'iban',
    'card_number',
    'pin',
    'password',
    'token',
    'secret',
  };

  KauriAnalyticsService(this._telemetry, this._logger);

  // ── OTel counter mapping ────────────────────────────────────────────────────

  /// Événements qui doivent également être enregistrés comme compteurs OTel
  /// (en plus du span d'événement) pour être visibles dans Prometheus via le
  /// connecteur SpanMetrics du OTel Collector.
  ///
  /// Seuls les attributs à faible cardinalité sont conservés comme labels
  /// Prometheus afin d'éviter l'explosion des séries temporelles.
  static const Map<String, Set<String>> _prometheusCounterLabels = {
    // Dépôts
    AnalyticsEvents.depositInitiated:    {'payment_method', 'provider', 'currency', 'amount_range'},
    AnalyticsEvents.depositCompleted:    {'payment_method', 'provider', 'currency', 'amount_range'},
    AnalyticsEvents.depositFailed:       {'payment_method', 'provider'},
    // Retraits
    AnalyticsEvents.withdrawalInitiated: {'provider', 'currency', 'amount_range'},
    AnalyticsEvents.withdrawalCompleted: {'provider', 'currency', 'amount_range'},
    AnalyticsEvents.withdrawalFailed:    {'provider'},
    // Transactions (send money + local)
    AnalyticsEvents.sendMoneyStarted:    {'entry_point'},
    AnalyticsEvents.sendMoneyCompleted:  {'payment_method', 'currency', 'amount_range'},
    AnalyticsEvents.sendMoneyFailed:     {'payment_method', 'at_step'},
    // Auth
    AnalyticsEvents.loginAttempt:        {'method', 'success'},
    AnalyticsEvents.logout:              {'reason'},
    // Erreurs
    AnalyticsEvents.blocError:           {'bloc_type', 'error_type'},
    AnalyticsEvents.apiError:            {'endpoint', 'status_code'},
  };

  // ── Sanitization ───────────────────────────────────────────────────────────

  /// Filtre les paramètres pour retirer toute donnée sensible avant envoi.
  Map<String, Object> _sanitize(Map<String, Object?>? params) {
    if (params == null) return {};
    return Map.fromEntries(
      params.entries
          .where((e) => !_sensitiveKeys.contains(e.key) && e.value != null)
          .map((e) => MapEntry(e.key, e.value!)),
    );
  }

  /// Hash SHA-256 d'un identifiant — jamais l'ID brut dans les analytics.
  String _hashUserId(String userId) {
    final bytes = utf8.encode(userId);
    return sha256.convert(bytes).toString();
  }

  // ── Interface publique ─────────────────────────────────────────────────────

  @override
  Future<void> logEvent(String name, {Map<String, Object?>? parameters}) async {
    final sanitized = _sanitize(parameters);
    try {
      // OpenTelemetry — span d'événement (traces / Jaeger)
      _telemetry.recordEvent(name, sanitized);

      // OTel counter span → Prometheus via SpanMetrics connector du OTel Collector.
      // Seuls les labels à faible cardinalité sont conservés pour éviter l'explosion
      // des séries temporelles dans Prometheus.
      final allowedLabels = _prometheusCounterLabels[name];
      if (allowedLabels != null) {
        final counterAttrs = Map<String, Object>.fromEntries(
          sanitized.entries.where((e) => allowedLabels.contains(e.key)),
        );
        _telemetry.recordCount(name, 1, attributes: counterAttrs);
      }

      // Log de dev uniquement
      if (kDebugMode) {
        debugPrint('📊 [Analytics] $name | ${sanitized.entries.map((e) => '${e.key}=${e.value}').join(', ')}');
      }
    } catch (e, stack) {
      // Ne jamais laisser l'analytique crasher l'app
      _logger.warning(
        'Analytics logEvent failed: $name',
        component: 'AnalyticsService',
        metadata: {'error': e.toString()},
      );
      if (kDebugMode) debugPrint('⚠️ [Analytics] logEvent error: $e\n$stack');
    }
  }

  @override
  Future<void> setUserProperty(String name, String value) async {
    try {
      _telemetry.recordEvent('user_property', {name: value});
    } catch (e) {
      if (kDebugMode) debugPrint('⚠️ [Analytics] setUserProperty error: $e');
    }
  }

  @override
  Future<void> setUserId(String? userId) async {
    try {
      if (userId != null && userId.isNotEmpty) {
        final hashed = _hashUserId(userId);
        // Définit l'ID hashé dans Crashlytics pour relier les crashes
        await FirebaseCrashlytics.instance.setCustomKey('user_id_hash', hashed);
        _telemetry.recordEvent('user_identified', {'user_id_hash': hashed});
        _logger.setUserId(hashed);
      } else {
        await FirebaseCrashlytics.instance.setCustomKey('user_id_hash', '');
        _logger.setUserId(null);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('⚠️ [Analytics] setUserId error: $e');
    }
  }

  @override
  Future<Future<void> Function({String? status, String? errorType})> startTrace(
    String traceName,
  ) async {
    Trace? firebaseTrace;
    final startTime = DateTime.now();

    try {
      firebaseTrace = FirebasePerformance.instance.newTrace(traceName);
      await firebaseTrace.start();
    } catch (e) {
      if (kDebugMode) debugPrint('⚠️ [Performance] startTrace error: $e');
    }

    return ({String? status, String? errorType}) async {
      final durationMs = DateTime.now().difference(startTime).inMilliseconds;
      try {
        if (status != null) firebaseTrace?.putAttribute('status', status);
        if (errorType != null) firebaseTrace?.putAttribute('error_type', errorType);
        await firebaseTrace?.stop();
      } catch (e) {
        if (kDebugMode) debugPrint('⚠️ [Performance] stopTrace error: $e');
      }
      // Envoie aussi la durée via OpenTelemetry
      _telemetry.recordGauge(
        'performance.$traceName',
        durationMs.toDouble(),
        attributes: {
          if (status != null) 'status': status,
          if (errorType != null) 'error_type': errorType,
        },
      );
    };
  }

  @override
  Future<T> withPerformanceTrace<T>(
    String traceName,
    Future<T> Function() operation,
  ) async {
    final stop = await startTrace(traceName);
    try {
      final result = await operation();
      await stop(status: 'success');
      return result;
    } catch (e) {
      await stop(status: 'error', errorType: e.runtimeType.toString());
      rethrow;
    }
  }

  @override
  void setCrashlyticsContext({
    String? screenName,
    String? lastAction,
    String? appState,
    String? networkState,
    String? walletState,
    String? blocState,
  }) {
    try {
      if (screenName != null) {
        FirebaseCrashlytics.instance.setCustomKey('screen_name', screenName);
      }
      if (lastAction != null) {
        FirebaseCrashlytics.instance.setCustomKey('last_action', lastAction);
      }
      if (appState != null) {
        FirebaseCrashlytics.instance.setCustomKey('app_state', appState);
      }
      if (networkState != null) {
        FirebaseCrashlytics.instance.setCustomKey('network_state', networkState);
      }
      if (walletState != null) {
        // walletState = 'loaded' | 'loading' | 'error' — JAMAIS le solde réel
        FirebaseCrashlytics.instance.setCustomKey('wallet_state', walletState);
      }
      if (blocState != null) {
        FirebaseCrashlytics.instance.setCustomKey('last_bloc_state', blocState);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('⚠️ [Analytics] setCrashlyticsContext error: $e');
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helper: Helpers de haut niveau pour les événements fréquents
// ─────────────────────────────────────────────────────────────────────────────

/// Extension pour les appels d'événements communs, à utiliser dans les BLoCs.
extension AnalyticsServiceX on AnalyticsService {
  // --- Navigation ---

  Future<void> logScreenView({
    required String screenName,
    required String screenClass,
    String? previousScreen,
    int? durationMs,
  }) => logEvent(AnalyticsEvents.screenView, parameters: {
    AnalyticsParams.screenName: screenName,
    AnalyticsParams.screenClass: screenClass,
    if (previousScreen != null) AnalyticsParams.previousScreen: previousScreen,
    if (durationMs != null) AnalyticsParams.durationMs: durationMs,
  });

  // --- Auth ---

  Future<void> logLoginAttempt({
    required String method,
    required bool success,
    String? failureReason,
    int attemptNumber = 1,
    int? durationMs,
  }) => logEvent(AnalyticsEvents.loginAttempt, parameters: {
    AnalyticsParams.method: method,
    AnalyticsParams.success: success,
    if (failureReason != null) AnalyticsParams.failureReason: failureReason,
    AnalyticsParams.attemptNumber: attemptNumber,
    if (durationMs != null) AnalyticsParams.durationMs: durationMs,
  });

  Future<void> logLogout({required String reason}) =>
      logEvent(AnalyticsEvents.logout, parameters: {
        AnalyticsParams.reason: reason,
      });

  Future<void> logSessionExpired({
    required String reason,
    String? screenName,
    int? sessionDurationSeconds,
  }) => logEvent(AnalyticsEvents.sessionExpired, parameters: {
    AnalyticsParams.reason: reason,
    if (screenName != null) AnalyticsParams.screenName: screenName,
    if (sessionDurationSeconds != null)
      AnalyticsParams.sessionDurationSeconds: sessionDurationSeconds,
  });

  // --- Transactions ---

  Future<void> logSendMoneyStarted({required String entryPoint}) =>
      logEvent(AnalyticsEvents.sendMoneyStarted, parameters: {
        AnalyticsParams.entryPoint: entryPoint,
      });

  Future<void> logSendMoneyCompleted({
    required String paymentMethod,
    required String currency,
    required num amount,
    String? provider,
    int? durationMs,
    int? totalFlowDurationMs,
  }) => logEvent(AnalyticsEvents.sendMoneyCompleted, parameters: {
    AnalyticsParams.paymentMethod: paymentMethod,
    AnalyticsParams.currency: currency,
    AnalyticsParams.amountRange: AnalyticsAmountRange.fromAmount(amount),
    if (provider != null) AnalyticsParams.provider: provider,
    if (durationMs != null) AnalyticsParams.durationMs: durationMs,
    if (totalFlowDurationMs != null)
      AnalyticsParams.totalFlowDurationMs: totalFlowDurationMs,
  });

  Future<void> logSendMoneyFailed({
    required String paymentMethod,
    required String reason,
    required String atStep,
    String? provider,
  }) => logEvent(AnalyticsEvents.sendMoneyFailed, parameters: {
    AnalyticsParams.paymentMethod: paymentMethod,
    AnalyticsParams.reason: reason,
    AnalyticsParams.atStep: atStep,
    if (provider != null) AnalyticsParams.provider: provider,
  });

  // --- Deposits ---

  Future<void> logDepositInitiated({
    required String paymentMethod,
    required String currency,
    required num amount,
    String? provider,
  }) => logEvent(AnalyticsEvents.depositInitiated, parameters: {
    AnalyticsParams.paymentMethod: paymentMethod,
    AnalyticsParams.currency: currency,
    AnalyticsParams.amountRange: AnalyticsAmountRange.fromAmount(amount),
    if (provider != null) AnalyticsParams.provider: provider,
  });

  Future<void> logDepositCompleted({
    required String paymentMethod,
    required String currency,
    required num amount,
    String? provider,
    int? durationMs,
  }) => logEvent(AnalyticsEvents.depositCompleted, parameters: {
    AnalyticsParams.paymentMethod: paymentMethod,
    AnalyticsParams.currency: currency,
    AnalyticsParams.amountRange: AnalyticsAmountRange.fromAmount(amount),
    if (provider != null) AnalyticsParams.provider: provider,
    if (durationMs != null) AnalyticsParams.durationMs: durationMs,
  });

  Future<void> logDepositFailed({
    required String paymentMethod,
    required String reason,
    String? provider,
  }) => logEvent(AnalyticsEvents.depositFailed, parameters: {
    AnalyticsParams.paymentMethod: paymentMethod,
    AnalyticsParams.reason: reason,
    if (provider != null) AnalyticsParams.provider: provider,
  });

  // --- Withdrawals ---

  Future<void> logWithdrawalInitiated({
    required String currency,
    required num amount,
    String? provider,
  }) => logEvent(AnalyticsEvents.withdrawalInitiated, parameters: {
    AnalyticsParams.currency: currency,
    AnalyticsParams.amountRange: AnalyticsAmountRange.fromAmount(amount),
    if (provider != null) AnalyticsParams.provider: provider,
  });

  Future<void> logWithdrawalCompleted({
    required String currency,
    required num amount,
    String? provider,
    int? durationMs,
  }) => logEvent(AnalyticsEvents.withdrawalCompleted, parameters: {
    AnalyticsParams.currency: currency,
    AnalyticsParams.amountRange: AnalyticsAmountRange.fromAmount(amount),
    if (provider != null) AnalyticsParams.provider: provider,
    if (durationMs != null) AnalyticsParams.durationMs: durationMs,
  });

  Future<void> logWithdrawalFailed({
    required String reason,
    String? provider,
  }) => logEvent(AnalyticsEvents.withdrawalFailed, parameters: {
    AnalyticsParams.reason: reason,
    if (provider != null) AnalyticsParams.provider: provider,
  });

  // --- Transactions locales ---

  Future<void> logTransactionAdded({
    required String currency,
    required num amount,
    required String type,
    required String category,
  }) => logEvent(AnalyticsEvents.sendMoneyCompleted, parameters: {
    AnalyticsParams.paymentMethod: 'manual',
    AnalyticsParams.currency: currency,
    AnalyticsParams.amountRange: AnalyticsAmountRange.fromAmount(amount),
    AnalyticsParams.type: type,
    'category': category,
  });

  // --- API Errors ---

  Future<void> logApiError({
    required String endpoint,
    required int statusCode,
    String? errorCode,
    int? durationMs,
    int retryCount = 0,
    String? networkType,
  }) => logEvent(AnalyticsEvents.apiError, parameters: {
    AnalyticsParams.endpoint: endpoint,
    AnalyticsParams.statusCode: statusCode,
    if (errorCode != null) AnalyticsParams.errorCode: errorCode,
    if (durationMs != null) AnalyticsParams.durationMs: durationMs,
    AnalyticsParams.retryCount: retryCount,
    if (networkType != null) AnalyticsParams.networkType: networkType,
  });
}
