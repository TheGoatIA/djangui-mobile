import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/transaction_model.dart';
import '../../domain/repositories/transaction_repository.dart';

import 'package:kauri/core/analytics/analytics_service.dart';
import 'package:kauri/core/services/log_service.dart';
import 'package:kauri/core/services/telemetry_service.dart';
import 'package:kauri/di/injection.dart';
import 'package:opentelemetry/api.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

@lazySingleton
class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final TransactionRepository _transactionRepository;
  TelemetryService get _telemetry => getIt<TelemetryService>();
  LogService get _logger => getIt<LogService>();
  AnalyticsService get _analytics => getIt<AnalyticsService>();

  TransactionsBloc(this._transactionRepository)
    : super(TransactionsState.initial()) {
    on<GetTransactionsRequested>(_onGetTransactionsRequested);
    on<AddTransactionRequested>(_onAddTransactionRequested);
    on<DeleteTransactionRequested>(_onDeleteTransactionRequested);
    on<ResetTransactionsStatus>(_onResetTransactionsStatus);
  }

  void _onResetTransactionsStatus(
    ResetTransactionsStatus event,
    Emitter<TransactionsState> emit,
  ) {
    emit(state.copyWith(status: TransactionsStatus.initial));
  }

  Future<void> _onGetTransactionsRequested(
    GetTransactionsRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    _logger.info(
      'Récupération de la liste des transactions...',
      component: 'TransactionsBloc',
    );
    emit(state.copyWith(status: TransactionsStatus.loading));
    final result = await _transactionRepository.getTransactions(
      forceRefresh: event.forceRefresh,
    );
    result.fold<void>(
      (failure) {
        _logger.error(
          'Échec de la récupération des transactions',
          error: failure.message,
          component: 'TransactionsBloc',
        );
        emit(
          state.copyWith(
            status: TransactionsStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (transactions) {
        _logger.info(
          '${transactions.length} transactions récupérées.',
          component: 'TransactionsBloc',
        );
        emit(
          state.copyWith(
            status: TransactionsStatus.success,
            transactions: transactions,
          ),
        );
      },
    );
  }

  Future<void> _onAddTransactionRequested(
    AddTransactionRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    final span = _telemetry.tracer.startSpan(
      'Transaction: Create',
      kind: SpanKind.internal,
    );
    span.setAttribute(
      Attribute.fromString(
        'transaction.amount',
        event.transaction.amount.toString(),
      ),
    );
    span.setAttribute(
      Attribute.fromString(
        'transaction.type',
        event.transaction.type.toString(),
      ),
    );

    try {
      _logger.info(
        'Tentative d\'ajout d\'une transaction...',
        component: 'TransactionsBloc',
        metadata: {
          'amount': event.transaction.amount,
          'category': event.transaction.category,
          'type': event.transaction.type.toString(),
        },
      );
      emit(state.copyWith(status: TransactionsStatus.loading));
      final result = await _transactionRepository.createTransaction(
        event.transaction,
      );
      result.fold<void>(
        (failure) {
          _logger.warning(
            'Échec de l\'ajout de la transaction',
            component: 'TransactionsBloc',
            metadata: {'error': failure.message},
          );
          span.setStatus(StatusCode.error, failure.message);
          emit(
            state.copyWith(
              status: TransactionsStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
        (transaction) {
          _logger.info(
            'Transaction ajoutée avec succès.',
            component: 'TransactionsBloc',
            metadata: {'id': transaction.id},
          );
          span.setAttribute(
            Attribute.fromString('transaction.id', transaction.id),
          );

          _telemetry.recordEvent('transaction.created', {
            'amount': event.transaction.amount,
            'currency': event.transaction.currency,
            'type': event.transaction.type,
            'category': event.transaction.category,
          });

          _analytics.logTransactionAdded(
            currency: event.transaction.currency,
            amount: event.transaction.amount,
            type: event.transaction.type.toString(),
            category: event.transaction.category,
          );

          final List<TransactionModel> updatedList = List.from(
            state.transactions,
          )..insert(0, transaction);
          emit(
            state.copyWith(
              status: TransactionsStatus.success,
              transactions: updatedList,
            ),
          );
        },
      );
    } catch (e, s) {
      span.recordException(e, stackTrace: s);
      rethrow;
    } finally {
      span.end();
    }
  }

  Future<void> _onDeleteTransactionRequested(
    DeleteTransactionRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    _logger.info(
      'Suppression de la transaction: ${event.id}',
      component: 'TransactionsBloc',
    );
    emit(state.copyWith(status: TransactionsStatus.loading));
    final result = await _transactionRepository.deleteTransaction(event.id);
    result.fold<void>(
      (failure) {
        _logger.error(
          'Échec de la suppression de la transaction',
          error: failure.message,
          component: 'TransactionsBloc',
        );
        emit(
          state.copyWith(
            status: TransactionsStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        _logger.info(
          'Transaction supprimée avec succès.',
          component: 'TransactionsBloc',
        );
        final List<TransactionModel> updatedList = state.transactions
            .where((t) => t.id != event.id)
            .toList();
        emit(
          state.copyWith(
            status: TransactionsStatus.success,
            transactions: updatedList,
          ),
        );
      },
    );
  }
}
