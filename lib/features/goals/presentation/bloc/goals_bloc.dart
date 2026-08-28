import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/goal_model.dart';
import '../../domain/repositories/goal_repository.dart';
import 'goals_event.dart';
import 'goals_state.dart';

import 'package:kauri/core/services/log_service.dart';
import 'package:kauri/core/services/telemetry_service.dart';
import 'package:kauri/di/injection.dart';
import 'package:opentelemetry/api.dart';

@lazySingleton
class GoalsBloc extends Bloc<GoalsEvent, GoalsState> {
  final GoalRepository _goalRepository;
  TelemetryService get _telemetry => getIt<TelemetryService>();
  LogService get _logger => getIt<LogService>();

  GoalsBloc(this._goalRepository) : super(GoalsState.initial()) {
    on<GetGoalsRequested>(_onGetGoalsRequested);
    on<AddGoalRequested>(_onAddGoalRequested, transformer: droppable());
    on<DeleteGoalRequested>(_onDeleteGoalRequested, transformer: droppable());
    on<UpdateGoalAmountRequested>(
      _onUpdateGoalAmountRequested,
      transformer: droppable(),
    );
    on<RedeemGoalRequested>(
      _onRedeemGoalRequested,
      transformer: droppable(),
    );
    on<ShareGoalRequested>(_onShareGoalRequested, transformer: droppable());
    on<JoinGoalRequested>(_onJoinGoalRequested, transformer: droppable());
    on<GetGoalParticipantsRequested>(_onGetGoalParticipantsRequested);
    on<RemoveGoalParticipantRequested>(_onRemoveGoalParticipantRequested);
    on<LeaveGoalRequested>(_onLeaveGoalRequested, transformer: droppable());
    on<ResetGoalsStatus>(_onResetGoalsStatus);
  }

  void _onResetGoalsStatus(ResetGoalsStatus event, Emitter<GoalsState> emit) {
    emit(GoalsState.initial());
  }

  Future<void> _onGetGoalsRequested(
    GetGoalsRequested event,
    Emitter<GoalsState> emit,
  ) async {
    _logger.info(
      'Récupération de la liste des objectifs...',
      component: 'GoalsBloc',
    );
    emit(state.copyWith(status: GoalsStatus.loading));
    final result = await _goalRepository.getGoals(
      forceRefresh: event.forceRefresh,
    );
    result.fold<void>(
      (failure) {
        _logger.error(
          'Échec de la récupération des objectifs',
          error: failure.message,
          component: 'GoalsBloc',
        );
        emit(
          state.copyWith(
            status: GoalsStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (goals) {
        _logger.info(
          '${goals.length} objectifs récupérés.',
          component: 'GoalsBloc',
        );
        emit(state.copyWith(status: GoalsStatus.success, goals: goals));
      },
    );
  }

  Future<void> _onAddGoalRequested(
    AddGoalRequested event,
    Emitter<GoalsState> emit,
  ) async {
    final span = _telemetry.tracer.startSpan(
      'Goal: Create',
      kind: SpanKind.internal,
    );
    span.setAttribute(Attribute.fromString('goal.name', event.goal.name));
    span.setAttribute(
      Attribute.fromString(
        'goal.target_amount',
        event.goal.targetAmount.toString(),
      ),
    );

    try {
      _logger.info(
        'Tentative de création d\'un objectif...',
        component: 'GoalsBloc',
        metadata: {'name': event.goal.name, 'target': event.goal.targetAmount},
      );
      emit(state.copyWith(status: GoalsStatus.loading));
      final result = await _goalRepository.createGoal(event.goal);
      result.fold<void>(
        (failure) {
          _logger.warning(
            'Échec de la création de l\'objectif',
            component: 'GoalsBloc',
            metadata: {'error': failure.message},
          );
          span.setStatus(StatusCode.error, failure.message);
          emit(
            state.copyWith(
              status: GoalsStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
        (goal) {
          _logger.info(
            'Objectif créé avec succès.',
            component: 'GoalsBloc',
            metadata: {'id': goal.id},
          );
          span.setAttribute(Attribute.fromString('goal.id', goal.id));
          final List<GoalModel> updatedList = List.from(state.goals)..add(goal);
          emit(
            state.copyWith(status: GoalsStatus.goalCreated, goals: updatedList),
          );
        },
      );
    } catch (e, s) {
      span.recordException(e, stackTrace: s);
      rethrow;
    } finally {
      span.end();
    }
  }

  Future<void> _onDeleteGoalRequested(
    DeleteGoalRequested event,
    Emitter<GoalsState> emit,
  ) async {
    _logger.info(
      'Suppression de l\'objectif: ${event.id}',
      component: 'GoalsBloc',
    );
    emit(state.copyWith(status: GoalsStatus.loading));
    final result = await _goalRepository.deleteGoal(event.id);
    result.fold<void>(
      (failure) {
        _logger.error(
          'Échec de la suppression de l\'objectif',
          error: failure.message,
          component: 'GoalsBloc',
        );
        emit(
          state.copyWith(
            status: GoalsStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        _logger.info('Objectif supprimé avec succès.', component: 'GoalsBloc');
        final List<GoalModel> updatedList = state.goals
            .where((g) => g.id != event.id)
            .toList();
        emit(
          state.copyWith(status: GoalsStatus.deleteSuccess, goals: updatedList),
        );
      },
    );
  }

  Future<void> _onUpdateGoalAmountRequested(
    UpdateGoalAmountRequested event,
    Emitter<GoalsState> emit,
  ) async {
    _logger.info(
      'Contribution à l\'objectif: ${event.id}',
      component: 'GoalsBloc',
      metadata: {'amount': event.amount},
    );
    emit(state.copyWith(status: GoalsStatus.loading));
    final result = await _goalRepository.updateGoalAmount(
      event.id,
      event.amount,
      note: event.note,
    );
    result.fold<void>(
      (failure) {
        _logger.error(
          'Échec de la contribution à l\'objectif',
          error: failure.message,
          component: 'GoalsBloc',
        );
        emit(
          state.copyWith(
            status: GoalsStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (updatedGoal) {
        _logger.info(
          'Contribution enregistrée avec succès.',
          component: 'GoalsBloc',
        );
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

  Future<void> _onRedeemGoalRequested(
    RedeemGoalRequested event,
    Emitter<GoalsState> emit,
  ) async {
    _logger.info(
      'Rachat de l\'objectif: ${event.id}',
      component: 'GoalsBloc',
      metadata: {'amount': event.amount},
    );
    emit(state.copyWith(status: GoalsStatus.loading));
    final result = await _goalRepository.redeemGoal(event.id, event.amount);
    result.fold<void>(
      (failure) {
        _logger.error(
          'Échec du rachat de l\'objectif',
          error: failure.message,
          component: 'GoalsBloc',
        );
        emit(
          state.copyWith(
            status: GoalsStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (updatedGoal) {
        _logger.info('Rachat enregistré avec succès.', component: 'GoalsBloc');
        final List<GoalModel> updatedList = state.goals
            .map((g) => g.id == updatedGoal.id ? updatedGoal : g)
            .toList();

        // Specific status for redemption to show a different message
        emit(
          state.copyWith(status: GoalsStatus.redeemSuccess, goals: updatedList),
        );
      },
    );
  }

  Future<void> _onShareGoalRequested(
    ShareGoalRequested event,
    Emitter<GoalsState> emit,
  ) async {
    emit(
      state.copyWith(
        shareStatus: GoalSideStatus.loading,
        shareInviteCode: () => null,
      ),
    );
    final result = await _goalRepository.shareGoal(event.goalId);
    result.fold<void>(
      (failure) {
        _logger.error(
          'Échec du partage de l\'objectif',
          error: failure.message,
          component: 'GoalsBloc',
        );
        emit(
          state.copyWith(
            shareStatus: GoalSideStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (inviteCode) => emit(
        state.copyWith(
          shareStatus: GoalSideStatus.success,
          shareInviteCode: () => inviteCode,
          goals: state.goals
              .map(
                (g) => g.id == event.goalId
                    ? g.copyWith(isShared: true, inviteCode: inviteCode)
                    : g,
              )
              .toList(),
        ),
      ),
    );
  }

  Future<void> _onJoinGoalRequested(
    JoinGoalRequested event,
    Emitter<GoalsState> emit,
  ) async {
    // Statut dédié (joinSuccess) plutôt que le `success` générique partagé
    // avec GetGoalsRequested : cette session a déjà rencontré et corrigé ce
    // piège pour la suppression d'objectif (un fetch de fond partageant le
    // même statut peut déclencher un listener par erreur).
    emit(state.copyWith(status: GoalsStatus.loading));
    final result = await _goalRepository.joinGoal(event.inviteCode);
    result.fold<void>(
      (failure) {
        _logger.error(
          'Échec pour rejoindre l\'objectif',
          error: failure.message,
          component: 'GoalsBloc',
        );
        emit(
          state.copyWith(
            status: GoalsStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (goal) {
        final updatedList = List<GoalModel>.from(state.goals)..add(goal);
        emit(
          state.copyWith(status: GoalsStatus.joinSuccess, goals: updatedList),
        );
      },
    );
  }

  Future<void> _onGetGoalParticipantsRequested(
    GetGoalParticipantsRequested event,
    Emitter<GoalsState> emit,
  ) async {
    emit(state.copyWith(participantsStatus: GoalSideStatus.loading));
    final result = await _goalRepository.getParticipants(event.goalId);
    result.fold<void>(
      (failure) {
        _logger.error(
          'Échec de la récupération des participants',
          error: failure.message,
          component: 'GoalsBloc',
        );
        emit(
          state.copyWith(
            participantsStatus: GoalSideStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (participants) => emit(
        state.copyWith(
          participantsStatus: GoalSideStatus.success,
          participants: participants,
        ),
      ),
    );
  }

  Future<void> _onRemoveGoalParticipantRequested(
    RemoveGoalParticipantRequested event,
    Emitter<GoalsState> emit,
  ) async {
    final result = await _goalRepository.removeParticipant(
      event.goalId,
      event.participantId,
    );
    result.fold<void>(
      (failure) {
        _logger.error(
          'Échec du retrait du participant',
          error: failure.message,
          component: 'GoalsBloc',
        );
        emit(
          state.copyWith(
            participantsStatus: GoalSideStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (_) => emit(
        state.copyWith(
          participants: state.participants
              .where((p) => p.id != event.participantId)
              .toList(),
        ),
      ),
    );
  }

  Future<void> _onLeaveGoalRequested(
    LeaveGoalRequested event,
    Emitter<GoalsState> emit,
  ) async {
    emit(state.copyWith(status: GoalsStatus.loading));
    final result = await _goalRepository.leaveGoal(event.goalId);
    result.fold<void>(
      (failure) {
        _logger.error(
          'Échec pour quitter l\'objectif',
          error: failure.message,
          component: 'GoalsBloc',
        );
        emit(
          state.copyWith(
            status: GoalsStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        final updatedList = state.goals
            .where((g) => g.id != event.goalId)
            .toList();
        emit(
          state.copyWith(status: GoalsStatus.leaveSuccess, goals: updatedList),
        );
      },
    );
  }
}
