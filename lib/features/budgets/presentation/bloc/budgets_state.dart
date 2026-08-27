import 'package:equatable/equatable.dart';
import '../../data/models/budget_model.dart';
import '../../data/models/auto_budget_response.dart';

enum BudgetsStatus { initial, loading, success, error }

// Statuts secondaires distincts du `status` principal (liste de budgets) pour
// que le chargement d'un historique ou d'une action de partage n'écrase pas
// l'état déjà chargé de la liste pendant que ces actions sont en cours.
enum BudgetSideStatus { initial, loading, success, error }

class BudgetsState extends Equatable {
  final BudgetsStatus status;
  final List<BudgetModel> budgets;
  final String? errorMessage;
  final AutoBudgetResponse? autoBudgetResponse;

  final BudgetSideStatus categoryHistoryStatus;
  final List<BudgetCategoryHistoryPointModel> categoryHistory;

  final BudgetSideStatus participantsStatus;
  final List<BudgetParticipantModel> participants;

  final BudgetSideStatus shareStatus;
  final String? shareInviteCode;

  const BudgetsState({
    this.status = BudgetsStatus.initial,
    this.budgets = const [],
    this.errorMessage,
    this.autoBudgetResponse,
    this.categoryHistoryStatus = BudgetSideStatus.initial,
    this.categoryHistory = const [],
    this.participantsStatus = BudgetSideStatus.initial,
    this.participants = const [],
    this.shareStatus = BudgetSideStatus.initial,
    this.shareInviteCode,
  });

  factory BudgetsState.initial() => const BudgetsState();

  BudgetsState copyWith({
    BudgetsStatus? status,
    List<BudgetModel>? budgets,
    String? errorMessage,
    AutoBudgetResponse? Function()? autoBudgetResponse,
    BudgetSideStatus? categoryHistoryStatus,
    List<BudgetCategoryHistoryPointModel>? categoryHistory,
    BudgetSideStatus? participantsStatus,
    List<BudgetParticipantModel>? participants,
    BudgetSideStatus? shareStatus,
    String? Function()? shareInviteCode,
  }) {
    return BudgetsState(
      status: status ?? this.status,
      budgets: budgets ?? this.budgets,
      errorMessage: errorMessage ?? this.errorMessage,
      autoBudgetResponse: autoBudgetResponse != null
          ? autoBudgetResponse()
          : this.autoBudgetResponse,
      categoryHistoryStatus: categoryHistoryStatus ?? this.categoryHistoryStatus,
      categoryHistory: categoryHistory ?? this.categoryHistory,
      participantsStatus: participantsStatus ?? this.participantsStatus,
      participants: participants ?? this.participants,
      shareStatus: shareStatus ?? this.shareStatus,
      shareInviteCode: shareInviteCode != null
          ? shareInviteCode()
          : this.shareInviteCode,
    );
  }

  @override
  List<Object?> get props => [
    status,
    budgets,
    errorMessage,
    autoBudgetResponse,
    categoryHistoryStatus,
    categoryHistory,
    participantsStatus,
    participants,
    shareStatus,
    shareInviteCode,
  ];
}
