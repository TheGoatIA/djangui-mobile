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

class GetCategoryHistoryRequested extends BudgetsEvent {
  final String category;
  final int monthsBack;

  const GetCategoryHistoryRequested({
    required this.category,
    this.monthsBack = 6,
  });

  @override
  List<Object?> get props => [category, monthsBack];
}

class ShareBudgetRequested extends BudgetsEvent {
  final String budgetId;

  const ShareBudgetRequested(this.budgetId);

  @override
  List<Object?> get props => [budgetId];
}

class JoinBudgetRequested extends BudgetsEvent {
  final String inviteCode;

  const JoinBudgetRequested(this.inviteCode);

  @override
  List<Object?> get props => [inviteCode];
}

class GetBudgetParticipantsRequested extends BudgetsEvent {
  final String budgetId;

  const GetBudgetParticipantsRequested(this.budgetId);

  @override
  List<Object?> get props => [budgetId];
}

class RemoveBudgetParticipantRequested extends BudgetsEvent {
  final String budgetId;
  final String participantId;

  const RemoveBudgetParticipantRequested(this.budgetId, this.participantId);

  @override
  List<Object?> get props => [budgetId, participantId];
}

class LeaveBudgetRequested extends BudgetsEvent {
  final String budgetId;

  const LeaveBudgetRequested(this.budgetId);

  @override
  List<Object?> get props => [budgetId];
}
