part of 'transactions_bloc.dart';

enum TransactionsStatus { initial, loading, success, error }

class TransactionsState extends Equatable {
  final TransactionsStatus status;
  final List<TransactionModel> transactions;
  final String? errorMessage;

  const TransactionsState({
    this.status = TransactionsStatus.initial,
    this.transactions = const [],
    this.errorMessage,
  });

  factory TransactionsState.initial() => const TransactionsState();

  TransactionsState copyWith({
    TransactionsStatus? status,
    List<TransactionModel>? transactions,
    String? errorMessage,
  }) {
    return TransactionsState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, transactions, errorMessage];
}
