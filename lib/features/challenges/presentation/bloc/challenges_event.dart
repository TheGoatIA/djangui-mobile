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

class UpdateChallengeProgressRequested extends ChallengesEvent {
  final String id;
  final double value;

  const UpdateChallengeProgressRequested({
    required this.id,
    required this.value,
  });

  @override
  List<Object?> get props => [id, value];
}
