import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'challenge_model.g.dart';

@JsonSerializable()
class ChallengeModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String title;
  final String description;
  final String type; // saving, spending_cut, habit
  final String difficulty; // easy, medium, hard
  final double? targetAmount;
  final int durationDays;
  final int rewardPoints;
  final String? icon;

  const ChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.targetAmount,
    required this.durationDays,
    required this.rewardPoints,
    this.icon,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) =>
      _$ChallengeModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChallengeModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    type,
    difficulty,
    targetAmount,
    durationDays,
    rewardPoints,
    icon,
  ];
}

@JsonSerializable()
class UserChallengeModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String status;
  final double progress;
  final double currentValue;
  final ChallengeModel? challengeId;
  final Map<String, dynamic>? flexibility;

  const UserChallengeModel({
    required this.id,
    required this.status,
    required this.progress,
    required this.currentValue,
    this.challengeId,
    this.flexibility,
  });

  factory UserChallengeModel.fromJson(Map<String, dynamic> json) =>
      _$UserChallengeModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserChallengeModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    status,
    progress,
    currentValue,
    challengeId,
    flexibility,
  ];
}
