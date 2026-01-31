import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/goal_model.dart';
import '../../domain/repositories/goal_repository.dart';
import 'goals_event.dart';
import 'goals_state.dart';

@injectable
class GoalsBloc extends Bloc<GoalsEvent, GoalsState> {
  final GoalRepository _goalRepository;

  GoalsBloc(this._goalRepository) : super(GoalsState.initial()) {
    on<GetGoalsRequested>(_onGetGoalsRequested);
    on<AddGoalRequested>(_onAddGoalRequested);
    on<DeleteGoalRequested>(_onDeleteGoalRequested);
    on<UpdateGoalAmountRequested>(_onUpdateGoalAmountRequested);
  }

  Future<void> _onGetGoalsRequested(
    GetGoalsRequested event,
    Emitter<GoalsState> emit,
  ) async {
    emit(state.copyWith(status: GoalsStatus.loading));
    final result = await _goalRepository.getGoals(
      forceRefresh: event.forceRefresh,
    );
    result.fold<void>(
      (failure) => emit(
        state.copyWith(
          status: GoalsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (goals) =>
          emit(state.copyWith(status: GoalsStatus.success, goals: goals)),
    );
  }

  Future<void> _onAddGoalRequested(
    AddGoalRequested event,
    Emitter<GoalsState> emit,
  ) async {
    emit(state.copyWith(status: GoalsStatus.loading));
    final result = await _goalRepository.createGoal(event.goal);
    result.fold<void>(
      (failure) => emit(
        state.copyWith(
          status: GoalsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (goal) {
        final List<GoalModel> updatedList = List.from(state.goals)..add(goal);
        emit(
          state.copyWith(status: GoalsStatus.goalCreated, goals: updatedList),
        );
      },
    );
  }

  Future<void> _onDeleteGoalRequested(
    DeleteGoalRequested event,
    Emitter<GoalsState> emit,
  ) async {
    emit(state.copyWith(status: GoalsStatus.loading));
    final result = await _goalRepository.deleteGoal(event.id);
    result.fold<void>(
      (failure) => emit(
        state.copyWith(
          status: GoalsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        final List<GoalModel> updatedList = state.goals
            .where((g) => g.id != event.id)
            .toList();
        emit(state.copyWith(status: GoalsStatus.success, goals: updatedList));
      },
    );
  }

  Future<void> _onUpdateGoalAmountRequested(
    UpdateGoalAmountRequested event,
    Emitter<GoalsState> emit,
  ) async {
    emit(state.copyWith(status: GoalsStatus.loading));
    final result = await _goalRepository.updateGoalAmount(
      event.id,
      event.amount,
    );
    result.fold<void>(
      (failure) => emit(
        state.copyWith(
          status: GoalsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (updatedGoal) {
        final List<GoalModel> updatedList = state.goals
            .map((g) => g.id == updatedGoal.id ? updatedGoal : g)
            .toList();
        emit(
          state.copyWith(
            status: GoalsStatus.contributionSuccess,
            goals: updatedList,
          ),
        );
      },
    );
  }
}
