import 'package:equatable/equatable.dart';

abstract class ChallengesEvent extends Equatable {
  const ChallengesEvent();

  @override
  List<Object?> get props => [];
}

class GetChallengesRequested extends ChallengesEvent {
  final bool forceRefresh;

  const GetChallengesRequested({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class JoinChallengeRequested extends ChallengesEvent {
  final String id;

  const JoinChallengeRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class GetUserChallengesRequested extends ChallengesEvent {}

class ValidateWeekRequested extends ChallengesEvent {
  final String userChallengeId;
  final int weekNumber;
  final double amount;
  final String? proofPath;

  const ValidateWeekRequested({
    required this.userChallengeId,
    required this.weekNumber,
    required this.amount,
    this.proofPath,
  });

  @override
  List<Object?> get props => [userChallengeId, weekNumber, amount, proofPath];
}

class UnjoinChallengeRequested extends ChallengesEvent {
  final String userChallengeId;

  const UnjoinChallengeRequested(this.userChallengeId);

  @override
  List<Object?> get props => [userChallengeId];
}

class SkipWeekRequested extends ChallengesEvent {
  final String userChallengeId;

  const SkipWeekRequested(this.userChallengeId);

  @override
  List<Object?> get props => [userChallengeId];
}

class PostponeDeadlineRequested extends ChallengesEvent {
  final String userChallengeId;

  const PostponeDeadlineRequested(this.userChallengeId);

  @override
  List<Object?> get props => [userChallengeId];
}
