import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/challenge_model.dart';
import '../../domain/repositories/challenge_repository.dart';
import 'challenges_event.dart';
import 'challenges_state.dart';

@injectable
class ChallengesBloc extends Bloc<ChallengesEvent, ChallengesState> {
  final ChallengeRepository _challengeRepository;

  ChallengesBloc(this._challengeRepository) : super(ChallengesState.initial()) {
    on<GetChallengesRequested>(_onGetChallengesRequested);
    on<JoinChallengeRequested>(_onJoinChallengeRequested);
    on<UpdateChallengeProgressRequested>(_onUpdateChallengeProgressRequested);
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
      (challenge) {
        final List<ChallengeModel> updatedList = state.challenges
            .map((c) => c.id == challenge.id ? challenge : c)
            .toList();
        emit(
          state.copyWith(
            status: ChallengesStatus.success,
            challenges: updatedList,
          ),
        );
      },
    );
  }

  Future<void> _onUpdateChallengeProgressRequested(
    UpdateChallengeProgressRequested event,
    Emitter<ChallengesState> emit,
  ) async {
    // Note: In a real app, we might not want to show loading for every small progress update
    final result = await _challengeRepository.updateProgress(
      event.id,
      event.value,
    );
    result.fold<void>(
      (failure) => emit(
        state.copyWith(
          status: ChallengesStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (challenge) {
        final List<ChallengeModel> updatedList = state.challenges
            .map((c) => c.id == challenge.id ? challenge : c)
            .toList();
        emit(
          state.copyWith(
            status: ChallengesStatus.success,
            challenges: updatedList,
          ),
        );
      },
    );
  }
}
