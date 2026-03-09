import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'analytics_service.dart';
import 'events.dart';

/// Observateur global de BLoC/Cubit pour l'instrumentation analytique.
///
/// Enregistre auprès de [Bloc.observer] dans [main.dart] :
/// ```dart
/// Bloc.observer = AnalyticsBlocObserver(getIt<AnalyticsService>());
/// ```
///
/// Ce qu'il fait :
///   - Met à jour les custom keys Crashlytics à chaque changement d'état
///   - Enregistre les erreurs BLoC comme événements analytics
///   - Facilite le débogage en loggant les transitions en mode debug
class AnalyticsBlocObserver extends BlocObserver {
  final AnalyticsService _analytics;

  AnalyticsBlocObserver(this._analytics);

  // ── États ──────────────────────────────────────────────────────────────────

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);

    final blocType = bloc.runtimeType.toString();
    final stateType = change.nextState.runtimeType.toString();

    // Met à jour le contexte Crashlytics à chaque changement d'état
    // pour enrichir les futurs crash reports
    _analytics.setCrashlyticsContext(blocState: '$blocType: $stateType');

    if (kDebugMode) {
      debugPrint('🔵 [BLoC] $blocType: ${change.currentState.runtimeType} → $stateType');
    }
  }

  // ── Transitions (Bloc uniquement, pas Cubit) ───────────────────────────────

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);

    if (kDebugMode) {
      debugPrint(
        '↔️ [BLoC] ${bloc.runtimeType}: '
        '${transition.currentState.runtimeType} '
        '─[${transition.event.runtimeType}]→ '
        '${transition.nextState.runtimeType}',
      );
    }
  }

  // ── Erreurs ─────────────────────────────────────────────────────────────────

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    final blocType = bloc.runtimeType.toString();
    final errorType = error.runtimeType.toString();

    // Enrichit le rapport Crashlytics avant que l'erreur ne remonte
    try {
      FirebaseCrashlytics.instance.setCustomKey(
        'last_bloc_error',
        '$blocType: $error',
      );
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: 'BLoC error in $blocType',
        fatal: false,
      );
    } catch (_) {
      // Ne pas propager les erreurs du reporter d'erreurs
    }

    // Événement analytics pour monitorer les erreurs BLoC
    _analytics.logEvent(AnalyticsEvents.blocError, parameters: {
      AnalyticsParams.blocType: blocType,
      AnalyticsParams.errorType: errorType,
    });

    if (kDebugMode) {
      debugPrint('🔴 [BLoC] Error in $blocType: $error');
    }
  }

  // ── Création / Fermeture ────────────────────────────────────────────────────

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    if (kDebugMode) {
      debugPrint('✅ [BLoC] Created: ${bloc.runtimeType}');
    }
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    if (kDebugMode) {
      debugPrint('🗑️ [BLoC] Closed: ${bloc.runtimeType}');
    }
  }
}
