import 'package:equatable/equatable.dart';
import '../../data/models/goal_model.dart';

enum GoalsStatus {
  initial,
  loading,
  success,
  error,
  goalCreated,
  contributionSuccess,
}

class GoalsState extends Equatable {
  final GoalsStatus status;
  final List<GoalModel> goals;
  final String? errorMessage;

  const GoalsState({
    this.status = GoalsStatus.initial,
    this.goals = const [],
    this.errorMessage,
  });

  factory GoalsState.initial() => const GoalsState();

  GoalsState copyWith({
    GoalsStatus? status,
    List<GoalModel>? goals,
    String? errorMessage,
  }) {
    return GoalsState(
      status: status ?? this.status,
      goals: goals ?? this.goals,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, goals, errorMessage];
}
