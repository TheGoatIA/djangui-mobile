import 'package:equatable/equatable.dart';
import '../../data/models/budget_model.dart';

abstract class BudgetsEvent extends Equatable {
  const BudgetsEvent();

  @override
  List<Object?> get props => [];
}

class GetBudgetsRequested extends BudgetsEvent {
  final bool forceRefresh;

  const GetBudgetsRequested({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class AddBudgetRequested extends BudgetsEvent {
  final BudgetModel budget;

  const AddBudgetRequested(this.budget);

  @override
  List<Object?> get props => [budget];
}

class DeleteBudgetRequested extends BudgetsEvent {
  final String id;

  const DeleteBudgetRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateBudgetRequested extends BudgetsEvent {
  final BudgetModel budget;

  const UpdateBudgetRequested(this.budget);

  @override
  List<Object?> get props => [budget];
}

class GenerateAutoBudgetRequested extends BudgetsEvent {
  final int? month;
  final int? year;

  const GenerateAutoBudgetRequested({this.month, this.year});

  @override
  List<Object?> get props => [month, year];
}

class ClearAutoBudgetResponse extends BudgetsEvent {
  const ClearAutoBudgetResponse();

  @override
  List<Object?> get props => [];
}

class ResetBudgetsStatus extends BudgetsEvent {}
