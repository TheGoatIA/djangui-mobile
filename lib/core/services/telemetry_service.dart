import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:kauri/core/config/env_config.dart';
import 'package:injectable/injectable.dart';
import 'package:opentelemetry/api.dart';
import 'package:opentelemetry/sdk.dart' as otel_sdk;

@singleton
class TelemetryService {
  Tracer? _tracer;
  Tracer? _metricsTracer;

  Tracer get tracer {
    if (_tracer == null) {
      // Fallback logger if not initialized
      return globalTracerProvider.getTracer('kauri-logger-fallback');
    }
    return _tracer!;
  }

  /// Specialized tracer for business metrics, sent to the metrics endpoint
  Tracer get metricsTracer {
    if (_metricsTracer == null) {
      return tracer; // Fallback to main tracer
    }
    return _metricsTracer!;
  }

  Future<void> initialize() async {
    try {
      final otelUrl = EnvConfig.otelEndpoint;

      final resource = otel_sdk.Resource([
        Attribute.fromString('service.name', 'kauri-mobile'),
        Attribute.fromString(
          'deployment.environment',
          kReleaseMode ? 'production' : 'development',
        ),
      ]);

      // --- TRACES CONFIG (System) ---
      if (otelUrl.isNotEmpty) {
        final uri = Uri.parse(otelUrl);
        // Using basic CollectorExporter which defaults to OTLP/HTTP Protobuf
        final processor = otel_sdk.BatchSpanProcessor(
          otel_sdk.CollectorExporter(uri),
        );

        final provider = otel_sdk.TracerProviderBase(
          processors: [processor],
          resource: resource,
        );

        registerGlobalTracerProvider(provider);
        _tracer = provider.getTracer('kauri-mobile-tracer');

        // CORRECTION: The Dart SDK 0.18.x only supports Traces.
        // Sending Spans to the Metrics endpoint (which expects OTLP Metrics) causes a 400 error.
        // We reuse the Trace provider to send "Metrics" as Spans with specific attributes.
        _metricsTracer = provider.getTracer('kauri-mobile-metrics');

        debugPrint(
          '✅ [Telemetry] Traces & Metrics initialized (sent as Spans to): $otelUrl',
        );
      }
    } catch (e, stack) {
      debugPrint('❌ [Telemetry] Initialization failed: $e');
      debugPrint(stack.toString());
    }
  }

  /// Records a cumulative count metric (Sent to metrics endpoint)
  void recordCount(String name, int value, {Map<String, Object>? attributes}) {
    _recordInternal(metricsTracer, name, {
      ...?attributes,
      'metric_type': 'counter',
      'metric_value': value,
    });
  }

  /// Records a gauge or point-in-time value (Sent to metrics endpoint)
  void recordGauge(
    String name,
    double value, {
    Map<String, Object>? attributes,
  }) {
    _recordInternal(metricsTracer, name, {
      ...?attributes,
      'metric_type': 'gauge',
      'metric_value': value,
    });
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
        recordGauge(
          'db.size',
          size.toDouble(),
          attributes: {'path': 'app_database.sqlite'},
        );
      }
    } catch (e) {
      debugPrint('⚠️ [Telemetry] Failed to record DB size: $e');
    }
  }

  /// Internal helper to record an event as a span
  void _recordInternal(
    Tracer targetTracer,
    String name,
    Map<String, Object> attributes,
  ) {
    final span = targetTracer.startSpan(name, kind: SpanKind.internal);
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

  /// Record a point-in-time event (equivalent to a Log)
  void recordEvent(String name, Map<String, Object> attributes) {
    _recordInternal(tracer, name, attributes);
  }
}
