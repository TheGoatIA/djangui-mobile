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

  const UpdateGoalAmountRequested({required this.id, required this.amount});

  @override
  List<Object?> get props => [id, amount];
}

class ResetGoalsStatus extends GoalsEvent {}
