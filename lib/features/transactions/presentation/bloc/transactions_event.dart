part of 'transactions_bloc.dart';

abstract class TransactionsEvent extends Equatable {
  const TransactionsEvent();

  @override
  List<Object?> get props => [];
}

class GetTransactionsRequested extends TransactionsEvent {
  final bool forceRefresh;

  const GetTransactionsRequested({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class AddTransactionRequested extends TransactionsEvent {
  final TransactionModel transaction;

  const AddTransactionRequested(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class DeleteTransactionRequested extends TransactionsEvent {
  final String id;

  const DeleteTransactionRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class ResetTransactionsStatus extends TransactionsEvent {}
