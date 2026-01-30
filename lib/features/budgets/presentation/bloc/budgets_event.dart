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
  final String id;
  final double totalAllocated;

  const UpdateBudgetRequested({required this.id, required this.totalAllocated});

  @override
  List<Object?> get props => [id, totalAllocated];
}

class GenerateAutoBudgetRequested extends BudgetsEvent {
  const GenerateAutoBudgetRequested();

  @override
  List<Object?> get props => [];
}

class ClearAutoBudgetResponse extends BudgetsEvent {
  const ClearAutoBudgetResponse();

  @override
  List<Object?> get props => [];
}
