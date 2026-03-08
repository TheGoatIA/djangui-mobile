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
  final String? note;

  const ValidateWeekRequested({
    required this.userChallengeId,
    required this.weekNumber,
    required this.amount,
    this.note,
  });

  @override
  List<Object?> get props => [userChallengeId, weekNumber, amount, note];
}

class UnjoinChallengeRequested extends ChallengesEvent {
  final String userChallengeId;

  const UnjoinChallengeRequested(this.userChallengeId);

  @override
  List<Object?> get props => [userChallengeId];
}

class SkipWeekRequested extends ChallengesEvent {
  final String userChallengeId;
  final int weekNumber;

  const SkipWeekRequested(this.userChallengeId, this.weekNumber);

  @override
  List<Object?> get props => [userChallengeId, weekNumber];
}

class PostponeDeadlineRequested extends ChallengesEvent {
  final String userChallengeId;
  final int weekNumber;

  const PostponeDeadlineRequested(this.userChallengeId, this.weekNumber);

  @override
  List<Object?> get props => [userChallengeId, weekNumber];
}

class RedeemChallengeRequested extends ChallengesEvent {
  final String userChallengeId;

  const RedeemChallengeRequested(this.userChallengeId);

  @override
  List<Object?> get props => [userChallengeId];
}
