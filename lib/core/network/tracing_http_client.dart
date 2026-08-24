import 'package:http/http.dart' as http;
import 'package:kauri/core/services/telemetry_service.dart';
import 'package:kauri/di/injection.dart';
import 'package:opentelemetry/api.dart';

/// A wrapper around [http.Client] that records Telemetry spans for each request.
///
/// Captures:
/// - Latency (via Span duration)
/// - HTTP Method & URL
/// - Status Code
/// - Network Errors (Timeout, SocketException)
class TracingHttpClient extends http.BaseClient {
  final http.Client _inner;
  TelemetryService? _telemetry;

  TracingHttpClient({http.Client? inner}) : _inner = inner ?? http.Client();

  TelemetryService get telemetry => _telemetry ??= getIt<TelemetryService>();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Start Span
    final span = telemetry.tracer.startSpan(
      'HTTP ${request.method}',
      kind: SpanKind.client,
    );

    // Add Attributes
    span.setAttribute(Attribute.fromString('http.method', request.method));
    span.setAttribute(Attribute.fromString('http.url', request.url.toString()));
    span.setAttribute(Attribute.fromString('http.host', request.url.host));

    // Inject W3C Trace Context directly on the request headers
    final traceId = span.spanContext.traceId.toString();
    final spanId = span.spanContext.spanId.toString();
    final traceFlags = span.spanContext.traceFlags.toString().padLeft(2, '0');
    final traceParent = '00-$traceId-$spanId-$traceFlags';

    request.headers['traceparent'] = traceParent;

    try {
      final response = await _inner.send(request).timeout(
        const Duration(seconds: 20),
      );

      // Record Status
      span.setAttribute(
        Attribute.fromInt('http.status_code', response.statusCode),
      );

      if (response.statusCode >= 400) {
        span.setStatus(StatusCode.error);
        telemetry.recordCount(
          'http.request.error',
          1,
          attributes: {
            'method': request.method,
            'url': request.url.path,
            'status_code': response.statusCode,
            'error_category': response.statusCode >= 500 ? 'server' : 'client',
          },
        );
      } else {
        span.setStatus(StatusCode.ok);
        telemetry.recordCount(
          'http.request.success',
          1,
          attributes: {
            'method': request.method,
            'url': request.url.path,
            'status_code': response.statusCode,
          },
        );
      }

      // We don't wait for the stream to complete to end the span for latency
      // effectively, we measure "time to first byte" / headers received.
      span.end();

      return response;
    } catch (e, stack) {
      // Record Error
      span.setAttribute(
        Attribute.fromString('error.type', e.runtimeType.toString()),
      );
      span.setAttribute(Attribute.fromString('error.message', e.toString()));

      telemetry.recordCount(
        'http.request.fault',
        1,
        attributes: {
          'method': request.method,
          'url': request.url.path,
          'error_type': e.runtimeType.toString(),
        },
      );

      span.recordException(e, stackTrace: stack);
      span.setStatus(StatusCode.error);
      span.end();
      rethrow;
    }
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}
