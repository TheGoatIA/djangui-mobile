import 'package:flutter/widgets.dart';
import 'package:kauri/core/services/log_service.dart';
import 'package:kauri/core/services/telemetry_service.dart';
import 'package:kauri/di/injection.dart';
import 'package:opentelemetry/api.dart';

class TelemetryRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  TelemetryService get _telemetry => getIt<TelemetryService>();
  LogService get _logger => getIt<LogService>();

  String? _currentRoute;
  DateTime? _entryTime;

  void _recordScreenDuration() {
    if (_currentRoute != null && _entryTime != null) {
      final duration = DateTime.now().difference(_entryTime!).inSeconds;
      _telemetry.recordGauge(
        'ux.screen_visit.duration',
        duration.toDouble(),
        attributes: {'screen_name': _currentRoute!},
      );
    }
  }

  void _traceNavigation(String event, String? routeName) {
    if (routeName == null) return;

    // Record duration for the screen we are leaving
    if (event == 'push' || event == 'replace') {
      _recordScreenDuration();
      _currentRoute = routeName;
      _entryTime = DateTime.now();

      // Telemetry: Screen Visit (Prometheus Count)
      _telemetry.recordCount(
        'ux.screen_visit.total',
        1,
        attributes: {'screen_name': routeName},
      );

      // Graylog: Navigation tracking
      _logger.info(
        'Visite de l\'écran: $routeName',
        component: 'Navigation',
        page: routeName,
        metadata: {'event': event},
      );
    }

    final span = _telemetry.tracer.startSpan(
      'Navigation: $routeName',
      kind: SpanKind.internal,
    );

    span.setAttribute(Attribute.fromString('navigation.event', event));
    span.setAttribute(Attribute.fromString('navigation.route', routeName));

    span.end();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _traceNavigation(
        'push',
        route.settings.name ?? route.settings.arguments?.toString(),
      );
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);

    // Leaving the current route
    _recordScreenDuration();

    if (previousRoute is PageRoute && previousRoute.settings.name != null) {
      _currentRoute = previousRoute.settings.name;
      _entryTime = DateTime.now();
      _traceNavigation('pop_to', previousRoute.settings.name);
    } else {
      _currentRoute = null;
      _entryTime = null;
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _traceNavigation('replace', newRoute.settings.name);
    }
  }
}
