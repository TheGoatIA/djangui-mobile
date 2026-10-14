import 'package:equatable/equatable.dart';
import '../../data/models/goal_model.dart';

abstract class GoalsEvent extends Equatable {
  const GoalsEvent();

  @override
  List<Object?> get props => [];
}

class GetGoalsRequested extends GoalsEvent {
  final bool forceRefresh;

  const GetGoalsRequested({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class AddGoalRequested extends GoalsEvent {
  final GoalModel goal;

  const AddGoalRequested(this.goal);

  @override
  List<Object?> get props => [goal];
}

class DeleteGoalRequested extends GoalsEvent {
  final String id;

  const DeleteGoalRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateGoalAmountRequested extends GoalsEvent {
  final String id;
  final double amount;
  final String? note;

  const UpdateGoalAmountRequested({
    required this.id,
    required this.amount,
    this.note,
  });

  @override
  List<Object?> get props => [id, amount, note];
}

class RedeemGoalRequested extends GoalsEvent {
  final String id;
  final double? amount;

  const RedeemGoalRequested({required this.id, this.amount});

  @override
  List<Object?> get props => [id, amount];
}

class ResetGoalsStatus extends GoalsEvent {}

class ShareGoalRequested extends GoalsEvent {
  final String goalId;

  const ShareGoalRequested(this.goalId);

  @override
  List<Object?> get props => [goalId];
}

class JoinGoalRequested extends GoalsEvent {
  final String inviteCode;

  const JoinGoalRequested(this.inviteCode);

  @override
  List<Object?> get props => [inviteCode];
}

class GetGoalParticipantsRequested extends GoalsEvent {
  final String goalId;

  const GetGoalParticipantsRequested(this.goalId);

  @override
  List<Object?> get props => [goalId];
}

class RemoveGoalParticipantRequested extends GoalsEvent {
  final String goalId;
  final String participantId;

  const RemoveGoalParticipantRequested(this.goalId, this.participantId);

  @override
  List<Object?> get props => [goalId, participantId];
}

class LeaveGoalRequested extends GoalsEvent {
  final String goalId;

  const LeaveGoalRequested(this.goalId);

  @override
  List<Object?> get props => [goalId];
}
