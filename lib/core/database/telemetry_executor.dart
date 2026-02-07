import 'dart:async';
import 'package:drift/drift.dart';
import 'package:kauri/core/services/telemetry_service.dart';
import 'package:kauri/di/injection.dart';
import 'package:opentelemetry/api.dart';

/// Wraps a [QueryExecutor] to record Telemetry spans for database operations.
class TelemetryQueryExecutor extends QueryExecutor {
  final QueryExecutor _inner;
  TelemetryService? _telemetry;

  TelemetryQueryExecutor(this._inner);

  TelemetryService get telemetry => _telemetry ??= getIt<TelemetryService>();

  // @override - Not overriding in this Drift version
  QueryExecutor get startingExecutor => _inner;

  @override
  SqlDialect get dialect => _inner.dialect;

  @override
  TransactionExecutor beginTransaction() {
    return _inner.beginTransaction();
  }

  @override
  Future<bool> ensureOpen(QueryExecutorUser user) => _inner.ensureOpen(user);

  // ignore: override_on_non_overriding_member
  @override
  QueryExecutor beginExclusive() {
    // This calls the inner beginExclusive if it exists, otherwise throws.
    // Assuming _inner has it or we just wrap a transaction.
    // For now, let's just delegate to inner if possible or throw as the user found out it's a void signature mismatch.
    // Actually, Drift 2.0+ `beginExclusive` returns a `QueryExecutor` (or void depending on version).
    // The error says "QueryExecutor beginExclusive()".
    return _inner.beginExclusive();
  }

  @override
  Future<void> runBatched(BatchedStatements statements) async {
    final span = telemetry.tracer.startSpan('DB Batch', kind: SpanKind.client);
    span.setAttribute(Attribute.fromString('db.system', 'sqlite'));
    span.setAttribute(
      Attribute.fromInt('db.batch_size', statements.statements.length),
    );

    try {
      await _inner.runBatched(statements);
      span.setStatus(StatusCode.ok);
    } catch (e, stack) {
      span.recordException(e, stackTrace: stack);
      span.setStatus(StatusCode.error);
      rethrow;
    } finally {
      span.end();
    }
  }

  @override
  Future<void> runCustom(String statement, [List<Object?>? args]) async {
    final span = telemetry.tracer.startSpan('DB Exec', kind: SpanKind.client);
    span.setAttribute(Attribute.fromString('db.system', 'sqlite'));
    span.setAttribute(Attribute.fromString('db.statement', statement));

    try {
      await _inner.runCustom(statement, args);
      span.setStatus(StatusCode.ok);
    } catch (e, stack) {
      span.recordException(e, stackTrace: stack);
      span.setStatus(StatusCode.error);
      rethrow;
    } finally {
      span.end();
    }
  }

  @override
  Future<int> runDelete(String statement, List<Object?> args) async {
    return _trace(
      'DB Delete',
      statement,
      () => _inner.runDelete(statement, args),
    );
  }

  @override
  Future<int> runInsert(String statement, List<Object?> args) async {
    return _trace(
      'DB Insert',
      statement,
      () => _inner.runInsert(statement, args),
    );
  }

  @override
  Future<List<Map<String, Object?>>> runSelect(
    String statement,
    List<Object?> args,
  ) async {
    return _trace(
      'DB Select',
      statement,
      () => _inner.runSelect(statement, args),
    );
  }

  @override
  Future<int> runUpdate(String statement, List<Object?> args) async {
    return _trace(
      'DB Update',
      statement,
      () => _inner.runUpdate(statement, args),
    );
  }

  Future<T> _trace<T>(
    String name,
    String statement,
    Future<T> Function() action,
  ) async {
    final span = telemetry.tracer.startSpan(name, kind: SpanKind.client);
    span.setAttribute(Attribute.fromString('db.system', 'sqlite'));
    // Truncate long statements to avoid huge spans
    span.setAttribute(
      Attribute.fromString(
        'db.statement',
        statement.length > 200
            ? '${statement.substring(0, 200)}...'
            : statement,
      ),
    );

    try {
      final result = await action();
      span.setStatus(StatusCode.ok);
      return result;
    } catch (e, stack) {
      span.recordException(e, stackTrace: stack);
      span.setStatus(StatusCode.error);
      rethrow;
    } finally {
      span.end();
    }
  }
}
