import 'package:equatable/equatable.dart';
import '../../data/models/challenge_model.dart';

enum ChallengesStatus { initial, loading, success, error }

class ChallengesState extends Equatable {
  final ChallengesStatus status;
  final List<ChallengeModel> challenges;
  final String? errorMessage;

  const ChallengesState({
    this.status = ChallengesStatus.initial,
    this.challenges = const [],
    this.errorMessage,
  });

  factory ChallengesState.initial() => const ChallengesState();

  ChallengesState copyWith({
    ChallengesStatus? status,
    List<ChallengeModel>? challenges,
    String? errorMessage,
  }) {
    return ChallengesState(
      status: status ?? this.status,
      challenges: challenges ?? this.challenges,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, challenges, errorMessage];
}
