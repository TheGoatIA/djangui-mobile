import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/challenge_repository.dart';
import 'challenges_event.dart';
import 'challenges_state.dart';

@injectable
class ChallengesBloc extends Bloc<ChallengesEvent, ChallengesState> {
  final ChallengeRepository _challengeRepository;

  ChallengesBloc(this._challengeRepository) : super(ChallengesState.initial()) {
    on<GetChallengesRequested>(_onGetChallengesRequested);
    on<GetUserChallengesRequested>(_onGetUserChallengesRequested);
    on<JoinChallengeRequested>(_onJoinChallengeRequested);
    on<ValidateWeekRequested>(_onValidateWeekRequested);
  }

  Future<void> _onGetChallengesRequested(
    GetChallengesRequested event,
    Emitter<ChallengesState> emit,
  ) async {
    emit(state.copyWith(status: ChallengesStatus.loading));
    final result = await _challengeRepository.getChallenges(
      forceRefresh: event.forceRefresh,
    );
    result.fold<void>(
      (failure) => emit(
        state.copyWith(
          status: ChallengesStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (challenges) => emit(
        state.copyWith(
          status: ChallengesStatus.success,
          challenges: challenges,
        ),
      ),
    );
  }

  Future<void> _onGetUserChallengesRequested(
    GetUserChallengesRequested event,
    Emitter<ChallengesState> emit,
  ) async {
    emit(state.copyWith(status: ChallengesStatus.loading));
    final result = await _challengeRepository.getUserChallenges();
    result.fold<void>(
      (failure) => emit(
        state.copyWith(
          status: ChallengesStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (userChallenges) => emit(
        state.copyWith(
          status: ChallengesStatus.success,
          userChallenges: userChallenges,
        ),
      ),
    );
  }

  Future<void> _onJoinChallengeRequested(
    JoinChallengeRequested event,
    Emitter<ChallengesState> emit,
  ) async {
    emit(state.copyWith(status: ChallengesStatus.loading));
    final result = await _challengeRepository.joinChallenge(event.id);
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

  Future<void> _onValidateWeekRequested(
    ValidateWeekRequested event,
    Emitter<ChallengesState> emit,
  ) async {
    // Optimistic loading? or just background? For now, standard loading.
    final result = await _challengeRepository.validateWeek(
      userChallengeId: event.userChallengeId,
      weekNumber: event.weekNumber,
      amount: event.amount,
    );
    result.fold<void>(
      (failure) => emit(
        state.copyWith(
          status: ChallengesStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        // Success
        add(GetUserChallengesRequested());
      },
    );
  }
}
