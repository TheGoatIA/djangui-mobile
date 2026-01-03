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

  const ValidateWeekRequested({
    required this.userChallengeId,
    required this.weekNumber,
    required this.amount,
  });

  @override
  List<Object?> get props => [userChallengeId, weekNumber, amount];
}
