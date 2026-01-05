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

  @_ChallengeIdConverter()
  final ChallengeModel? challengeId;
  final Map<String, dynamic>? flexibility;
  final List<ChallengeWeekModel>? weeks;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserChallengeModel({
    required this.id,
    required this.status,
    required this.progress,
    required this.currentValue,
    this.challengeId,
    this.flexibility,
    this.weeks,
    this.createdAt,
    this.updatedAt,
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
    weeks,
    createdAt,
    updatedAt,
  ];
}

@JsonSerializable()
class ChallengeWeekModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final int weekNumber;
  final double targetAmount;
  final double savedAmount;
  final String status;

  const ChallengeWeekModel({
    required this.id,
    required this.weekNumber,
    required this.targetAmount,
    required this.savedAmount,
    required this.status,
  });

  factory ChallengeWeekModel.fromJson(Map<String, dynamic> json) =>
      _$ChallengeWeekModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChallengeWeekModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    weekNumber,
    targetAmount,
    savedAmount,
    status,
  ];
}

class _ChallengeIdConverter implements JsonConverter<ChallengeModel?, dynamic> {
  const _ChallengeIdConverter();

  @override
  ChallengeModel? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is Map<String, dynamic>) {
      return ChallengeModel.fromJson(json);
    }
    if (json is String) {
      // If it's just an ID, we return a skeleton model so that we can still access the ID
      return ChallengeModel(
        id: json,
        title: '',
        description: '',
        type: '',
        difficulty: '',
        targetAmount: null,
        durationDays: 0,
        rewardPoints: 0,
      );
    }
    return null;
  }

  @override
  dynamic toJson(ChallengeModel? object) => object?.toJson();
}
