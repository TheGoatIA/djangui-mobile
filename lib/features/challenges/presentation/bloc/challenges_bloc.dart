import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/challenge_repository.dart';
import 'package:kauri/core/services/log_service.dart';
import 'package:kauri/core/services/telemetry_service.dart';
import 'package:kauri/di/injection.dart';

import 'challenges_event.dart';
import 'challenges_state.dart';

@injectable
class ChallengesBloc extends Bloc<ChallengesEvent, ChallengesState> {
  final ChallengeRepository _challengeRepository;
  TelemetryService get _telemetry => getIt<TelemetryService>();
  LogService get _logger => getIt<LogService>();

  ChallengesBloc(this._challengeRepository) : super(ChallengesState.initial()) {
    on<GetChallengesRequested>(_onGetChallengesRequested);
    on<GetUserChallengesRequested>(_onGetUserChallengesRequested);
    on<JoinChallengeRequested>(_onJoinChallengeRequested);
    on<ValidateWeekRequested>(_onValidateWeekRequested);
    on<UnjoinChallengeRequested>(_onUnjoinChallengeRequested);
    on<SkipWeekRequested>(_onSkipWeekRequested);
    on<PostponeDeadlineRequested>(_onPostponeDeadlineRequested);
    on<RedeemChallengeRequested>(_onRedeemChallengeRequested);
  }

  Future<void> _onGetChallengesRequested(
    GetChallengesRequested event,
    Emitter<ChallengesState> emit,
  ) async {
    _logger.info(
      'Récupération de la liste des défis...',
      component: 'ChallengesBloc',
    );
    emit(state.copyWith(status: ChallengesStatus.loading));
    final result = await _challengeRepository.getChallenges(
      forceRefresh: event.forceRefresh,
    );
    result.fold<void>(
      (failure) {
        _logger.error(
          'Échec de la récupération des défis',
          error: failure.message,
          component: 'ChallengesBloc',
        );
        emit(
          state.copyWith(
            status: ChallengesStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (challenges) {
        _logger.info(
          '${challenges.length} défis récupérés.',
          component: 'ChallengesBloc',
        );
        emit(
          state.copyWith(
            status: ChallengesStatus.success,
            challenges: challenges,
          ),
        );
      },
    );
  }

  Future<void> _onGetUserChallengesRequested(
    GetUserChallengesRequested event,
    Emitter<ChallengesState> emit,
  ) async {
    _logger.info(
      'Récupération de mes défis en cours...',
      component: 'ChallengesBloc',
    );
    emit(state.copyWith(status: ChallengesStatus.loading));
    final result = await _challengeRepository.getUserChallenges();
    result.fold<void>(
      (failure) {
        _logger.error(
          'Échec de la récupération de mes défis',
          error: failure.message,
          component: 'ChallengesBloc',
        );
        emit(
          state.copyWith(
            status: ChallengesStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (userChallenges) {
        _logger.info(
          '${userChallenges.length} défis utilisateur récupérés.',
          component: 'ChallengesBloc',
        );
        emit(
          state.copyWith(
            status: ChallengesStatus.success,
            userChallenges: userChallenges,
          ),
        );
      },
    );
  }

  Future<void> _onJoinChallengeRequested(
    JoinChallengeRequested event,
    Emitter<ChallengesState> emit,
  ) async {
    _logger.info(
      'Tentative d\'inscription au défi: ${event.id}',
      component: 'ChallengesBloc',
    );
    emit(state.copyWith(status: ChallengesStatus.loading));
    final result = await _challengeRepository.joinChallenge(event.id);
    result.fold<void>(
      (failure) {
        _logger.warning(
          'Échec de l\'inscription au défi',
          component: 'ChallengesBloc',
          metadata: {'error': failure.message},
        );
        emit(
          state.copyWith(
            status: ChallengesStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        _logger.info(
          'Inscription au défi réussie.',
          component: 'ChallengesBloc',
        );
        // Success, refresh challenges
        _telemetry.recordEvent('challenge.joined', {'challenge.id': event.id});
        add(const GetChallengesRequested(forceRefresh: true));
        add(GetUserChallengesRequested());
      },
    );
  }

  Future<void> _onValidateWeekRequested(
    ValidateWeekRequested event,
    Emitter<ChallengesState> emit,
  ) async {
    _logger.info(
      'Validation de la semaine ${event.weekNumber} pour le défi ${event.userChallengeId}',
      component: 'ChallengesBloc',
    );
    emit(state.copyWith(status: ChallengesStatus.loading));
    final result = await _challengeRepository.validateWeek(
      userChallengeId: event.userChallengeId,
      weekNumber: event.weekNumber,
      amount: event.amount,
      note: event.note,
    );
    result.fold<void>(
      (failure) {
        _logger.error(
          'Échec de la validation de la semaine',
          error: failure.message,
          component: 'ChallengesBloc',
        );
        emit(
          state.copyWith(
            status: ChallengesStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        _logger.info(
          'Semaine validée avec succès.',
          component: 'ChallengesBloc',
        );
        // Success
        _telemetry.recordEvent('challenge.validated', {
          'user_challenge.id': event.userChallengeId,
          'week.number': event.weekNumber,
          'amount': event.amount,
        });
        emit(state.copyWith(status: ChallengesStatus.success));
        add(GetUserChallengesRequested());
      },
    );
  }

  Future<void> _onUnjoinChallengeRequested(
    UnjoinChallengeRequested event,
    Emitter<ChallengesState> emit,
  ) async {
    emit(state.copyWith(status: ChallengesStatus.loading));
    final result = await _challengeRepository.unjoinChallenge(
      event.userChallengeId,
    );
    result.fold<void>(
      (failure) => emit(
        state.copyWith(
          status: ChallengesStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        // Success, refresh challenges
        add(const GetChallengesRequested(forceRefresh: true));
        add(GetUserChallengesRequested());
      },
    );
  }

  Future<void> _onSkipWeekRequested(
    SkipWeekRequested event,
    Emitter<ChallengesState> emit,
  ) async {
    _logger.info(
      'Action: Saut de semaine demandé',
      component: 'ChallengesBloc',
    );
    emit(state.copyWith(status: ChallengesStatus.loading));
    final result = await _challengeRepository.skipWeek(
      event.userChallengeId,
      event.weekNumber,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ChallengesStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        _telemetry.recordEvent('challenge.skip', {'id': event.userChallengeId});
        add(GetUserChallengesRequested());
      },
    );
  }

  Future<void> _onPostponeDeadlineRequested(
    PostponeDeadlineRequested event,
    Emitter<ChallengesState> emit,
  ) async {
    _logger.info(
      'Action: Report de deadline demandé',
      component: 'ChallengesBloc',
    );
    emit(state.copyWith(status: ChallengesStatus.loading));
    final result = await _challengeRepository.postponeDeadline(
      event.userChallengeId,
      event.weekNumber,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ChallengesStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        _telemetry.recordEvent('challenge.postpone', {
          'id': event.userChallengeId,
        });
        add(GetUserChallengesRequested());
      },
    );
  }

  Future<void> _onRedeemChallengeRequested(
    RedeemChallengeRequested event,
    Emitter<ChallengesState> emit,
  ) async {
    _logger.info(
      'Récupération des fonds du défi: ${event.userChallengeId}',
      component: 'ChallengesBloc',
    );
    emit(state.copyWith(status: ChallengesStatus.loading));
    final result = await _challengeRepository.redeemChallenge(
      event.userChallengeId,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ChallengesStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (redeemModel) {
        _logger.info(
          'Fonds récupérés avec succès. Montant: ${redeemModel.redeemedAmount}',
          component: 'ChallengesBloc',
        );
        _telemetry.recordEvent('challenge.redeem', {
          'id': event.userChallengeId,
          'amount': redeemModel.redeemedAmount,
        });
        emit(state.copyWith(status: ChallengesStatus.success));

        // Refresh challenges
        add(GetUserChallengesRequested());
      },
    );
  }
}
