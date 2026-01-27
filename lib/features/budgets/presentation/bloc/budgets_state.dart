import 'package:equatable/equatable.dart';
import '../../data/models/budget_model.dart';
import '../../data/models/auto_budget_response.dart';

enum BudgetsStatus { initial, loading, success, error }

class BudgetsState extends Equatable {
  final BudgetsStatus status;
  final List<BudgetModel> budgets;
  final String? errorMessage;
  final AutoBudgetResponse? autoBudgetResponse;

  const BudgetsState({
    this.status = BudgetsStatus.initial,
    this.budgets = const [],
    this.errorMessage,
    this.autoBudgetResponse,
  });

  factory BudgetsState.initial() => const BudgetsState();

  BudgetsState copyWith({
    BudgetsStatus? status,
    List<BudgetModel>? budgets,
    String? errorMessage,
    AutoBudgetResponse? Function()? autoBudgetResponse,
  }) {
    return BudgetsState(
      status: status ?? this.status,
      budgets: budgets ?? this.budgets,
      errorMessage: errorMessage ?? this.errorMessage,
      autoBudgetResponse: autoBudgetResponse != null
          ? autoBudgetResponse()
          : this.autoBudgetResponse,
    );
  }

  @override
  List<Object?> get props => [
    status,
    budgets,
    errorMessage,
    autoBudgetResponse,
  ];
}
