import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/transaction_model.dart';
import '../../domain/repositories/transaction_repository.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

@injectable
class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final TransactionRepository _transactionRepository;

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
    emit(state.copyWith(status: TransactionsStatus.loading));
    final result = await _transactionRepository.getTransactions(
      forceRefresh: event.forceRefresh,
    );
    result.fold<void>(
      (failure) => emit(
        state.copyWith(
          status: TransactionsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (transactions) => emit(
        state.copyWith(
          status: TransactionsStatus.success,
          transactions: transactions,
        ),
      ),
    );
  }

  Future<void> _onAddTransactionRequested(
    AddTransactionRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(state.copyWith(status: TransactionsStatus.loading));
    final result = await _transactionRepository.createTransaction(
      event.transaction,
    );
    result.fold<void>(
      (failure) => emit(
        state.copyWith(
          status: TransactionsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (transaction) {
        final List<TransactionModel> updatedList = List.from(state.transactions)
          ..insert(0, transaction);
        emit(
          state.copyWith(
            status: TransactionsStatus.success,
            transactions: updatedList,
          ),
        );
      },
    );
  }

  Future<void> _onDeleteTransactionRequested(
    DeleteTransactionRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(state.copyWith(status: TransactionsStatus.loading));
    final result = await _transactionRepository.deleteTransaction(event.id);
    result.fold<void>(
      (failure) => emit(
        state.copyWith(
          status: TransactionsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) {
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
