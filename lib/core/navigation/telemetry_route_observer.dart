import 'package:flutter/widgets.dart';
import 'package:kauri/core/services/telemetry_service.dart';
import 'package:kauri/di/injection.dart';
import 'package:opentelemetry/api.dart';

class TelemetryRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  TelemetryService get _telemetry => getIt<TelemetryService>();

  void _traceNavigation(String event, String? routeName) {
    if (routeName == null) return;

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
    if (previousRoute is PageRoute && previousRoute.settings.name != null) {
      _traceNavigation('pop_to', previousRoute.settings.name);
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
