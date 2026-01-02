import 'package:equatable/equatable.dart';
import '../../data/models/budget_model.dart';

enum BudgetsStatus { initial, loading, success, error }

class BudgetsState extends Equatable {
  final BudgetsStatus status;
  final List<BudgetModel> budgets;
  final String? errorMessage;

  const BudgetsState({
    this.status = BudgetsStatus.initial,
    this.budgets = const [],
    this.errorMessage,
  });

  factory BudgetsState.initial() => const BudgetsState();

  BudgetsState copyWith({
    BudgetsStatus? status,
    List<BudgetModel>? budgets,
    String? errorMessage,
  }) {
    return BudgetsState(
      status: status ?? this.status,
      budgets: budgets ?? this.budgets,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, budgets, errorMessage];
}
