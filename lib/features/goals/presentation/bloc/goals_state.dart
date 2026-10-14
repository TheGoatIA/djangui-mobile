import 'package:equatable/equatable.dart';
import '../../data/models/goal_model.dart';

enum GoalsStatus {
  initial,
  loading,
  success,
  error,
  goalCreated,
  contributionSuccess,
  redeemSuccess,
  deleteSuccess,
  joinSuccess,
  leaveSuccess,
}

// Statuts secondaires distincts du `status` principal (liste d'objectifs)
// pour que le partage/les participants n'écrasent pas l'état déjà chargé de
// la liste pendant que ces actions sont en cours — même pattern que
// BudgetSideStatus pour les budgets.
enum GoalSideStatus { initial, loading, success, error }

class GoalsState extends Equatable {
  final GoalsStatus status;
  final List<GoalModel> goals;
  final String? errorMessage;

  final GoalSideStatus participantsStatus;
  final List<GoalParticipantModel> participants;

  final GoalSideStatus shareStatus;
  final String? shareInviteCode;

  const GoalsState({
    this.status = GoalsStatus.initial,
    this.goals = const [],
    this.errorMessage,
    this.participantsStatus = GoalSideStatus.initial,
    this.participants = const [],
    this.shareStatus = GoalSideStatus.initial,
    this.shareInviteCode,
  });

  factory GoalsState.initial() => const GoalsState();

  GoalsState copyWith({
    GoalsStatus? status,
    List<GoalModel>? goals,
    String? errorMessage,
    GoalSideStatus? participantsStatus,
    List<GoalParticipantModel>? participants,
    GoalSideStatus? shareStatus,
    String? Function()? shareInviteCode,
  }) {
    return GoalsState(
      status: status ?? this.status,
      goals: goals ?? this.goals,
      errorMessage: errorMessage ?? this.errorMessage,
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
    goals,
    errorMessage,
    participantsStatus,
    participants,
    shareStatus,
    shareInviteCode,
  ];
}
