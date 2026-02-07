import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:opentelemetry/api.dart';
import 'package:opentelemetry/sdk.dart' as otel_sdk;

@singleton
class TelemetryService {
  Tracer? _tracer;

  Tracer get tracer {
    if (_tracer == null) {
      // Fallback logger if not initialized
      return globalTracerProvider.getTracer('kauri-logger-fallback');
    }
    return _tracer!;
  }

  Future<void> initialize() async {
    try {
      final otelUrl = dotenv.env['OTEL_EXPORTER_OTLP_ENDPOINT'];

      if (otelUrl == null || otelUrl.isEmpty) {
        debugPrint(
          '⚠️ [Telemetry] OTEL_EXPORTER_OTLP_ENDPOINT not set. Telemetry disabled.',
        );
        return;
      }

      final uri = Uri.parse(otelUrl);

      // Use BatchSpanProcessor for better performance
      final processor = otel_sdk.BatchSpanProcessor(
        otel_sdk.CollectorExporter(uri),
      );

      final provider = otel_sdk.TracerProviderBase(
        processors: [processor],
        resource: otel_sdk.Resource([
          Attribute.fromString('service.name', 'kauri-mobile'),
          Attribute.fromString(
            'deployment.environment',
            kReleaseMode ? 'production' : 'development',
          ),
        ]),
      );

      // Register globally
      registerGlobalTracerProvider(provider);

      _tracer = provider.getTracer('kauri-mobile-tracer');

      debugPrint('✅ [Telemetry] Initialized with endpoint: $otelUrl');
    } catch (e, stack) {
      debugPrint('❌ [Telemetry] Initialization failed: $e');
      debugPrint(stack.toString());
    }
  }

  /// Helper to trace a specific action
  Future<T> traceAction<T>(String name, Future<T> Function() action) async {
    final span = tracer.startSpan(name);
    try {
      return await action();
    } catch (e) {
      span.recordException(e);
      span.setStatus(StatusCode.error, e.toString());
      rethrow;
    } finally {
      span.end();
    }
  }

  /// Records the current SQLite database file size as a metric.
  Future<void> recordDatabaseSize() async {
    try {
      final dbFolder = await getApplicationDocumentsDirectory();
      final dbPath = p.join(dbFolder.path, 'app_database.sqlite');
      final file = File(dbPath);
      if (await file.exists()) {
        final size = await file.length();
        recordEvent('db.size', {
          'size_bytes': size,
          'path': 'app_database.sqlite',
        });
      }
    } catch (e) {
      debugPrint('⚠️ [Telemetry] Failed to record DB size: $e');
    }
  }

  /// Record a point-in-time event (equivalent to a Log or discrete Metric)
  void recordEvent(String name, Map<String, Object> attributes) {
    final span = tracer.startSpan(name, kind: SpanKind.internal);
    attributes.forEach((key, value) {
      if (value is String) {
        span.setAttribute(Attribute.fromString(key, value));
      } else if (value is int) {
        span.setAttribute(Attribute.fromInt(key, value));
      } else if (value is double) {
        span.setAttribute(Attribute.fromDouble(key, value));
      } else if (value is bool) {
        span.setAttribute(Attribute.fromBoolean(key, value));
      } else {
        span.setAttribute(Attribute.fromString(key, value.toString()));
      }
    });
    span.end();
  }
}
