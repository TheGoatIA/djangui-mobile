import 'package:equatable/equatable.dart';
import '../../data/models/challenge_model.dart';

enum ChallengesStatus { initial, loading, success, error }

class ChallengesState extends Equatable {
  final ChallengesStatus status;
  final List<ChallengeModel> challenges;
  final List<UserChallengeModel> userChallenges;
  final String? errorMessage;

  const ChallengesState({
    this.status = ChallengesStatus.initial,
    this.challenges = const <ChallengeModel>[],
    this.userChallenges = const <UserChallengeModel>[],
    this.errorMessage,
  });

  factory ChallengesState.initial() => const ChallengesState();

  ChallengesState copyWith({
    ChallengesStatus? status,
    List<ChallengeModel>? challenges,
    List<UserChallengeModel>? userChallenges,
    String? errorMessage,
  }) {
    return ChallengesState(
      status: status ?? this.status,
      challenges: challenges ?? this.challenges,
      userChallenges: userChallenges ?? this.userChallenges,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, challenges, userChallenges, errorMessage];
}
