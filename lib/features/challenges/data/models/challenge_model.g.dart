// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeModel _$ChallengeModelFromJson(Map<String, dynamic> json) =>
    ChallengeModel(
      id: ChallengeModel._idFromJson(json['_id']),
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      difficulty: json['difficulty'] as String,
      targetAmount: (json['targetAmount'] as num?)?.toDouble(),
      durationDays: (json['durationDays'] as num).toInt(),
      rewardPoints: (json['rewardPoints'] as num).toInt(),
      icon: json['icon'] as String?,
      requiresProof: json['requiresProof'] as bool? ?? false,
    );

Map<String, dynamic> _$ChallengeModelToJson(ChallengeModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': instance.type,
      'difficulty': instance.difficulty,
      'targetAmount': instance.targetAmount,
      'durationDays': instance.durationDays,
      'rewardPoints': instance.rewardPoints,
      'icon': instance.icon,
      'requiresProof': instance.requiresProof,
    };

UserChallengeModel _$UserChallengeModelFromJson(Map<String, dynamic> json) =>
    UserChallengeModel(
      id: UserChallengeModel._idFromJson(json['_id']),
      status: json['status'] as String,
      progress: (json['progress'] as num).toDouble(),
      currentValue: (json['currentValue'] as num).toDouble(),
      challengeId: const _ChallengeIdConverter().fromJson(json['challengeId']),
      flexibility: json['flexibility'] == null
          ? null
          : ChallengeFlexibilityModel.fromJson(
              json['flexibility'] as Map<String, dynamic>,
            ),
      weeks: (json['weeks'] as List<dynamic>?)
          ?.map((e) => ChallengeWeekModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserChallengeModelToJson(UserChallengeModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'status': instance.status,
      'progress': instance.progress,
      'currentValue': instance.currentValue,
      'challengeId': const _ChallengeIdConverter().toJson(instance.challengeId),
      'flexibility': instance.flexibility,
      'weeks': instance.weeks,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

ChallengeWeekModel _$ChallengeWeekModelFromJson(Map<String, dynamic> json) =>
    ChallengeWeekModel(
      id: ChallengeWeekModel._idFromJson(json['_id']),
      weekNumber: (json['weekNumber'] as num).toInt(),
      targetAmount: (json['targetAmount'] as num).toDouble(),
      savedAmount: (json['savedAmount'] as num).toDouble(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$ChallengeWeekModelToJson(ChallengeWeekModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'weekNumber': instance.weekNumber,
      'targetAmount': instance.targetAmount,
      'savedAmount': instance.savedAmount,
      'status': instance.status,
    };

ChallengeFlexibilityModel _$ChallengeFlexibilityModelFromJson(
  Map<String, dynamic> json,
) => ChallengeFlexibilityModel(
  skipsUsed: (json['skipsUsed'] as num?)?.toInt() ?? 0,
  maxSkips: (json['maxSkips'] as num?)?.toInt() ?? 3,
  postponementsUsed: (json['postponementsUsed'] as num?)?.toInt() ?? 0,
  nextDeadline: json['nextDeadline'] == null
      ? null
      : DateTime.parse(json['nextDeadline'] as String),
);

Map<String, dynamic> _$ChallengeFlexibilityModelToJson(
  ChallengeFlexibilityModel instance,
) => <String, dynamic>{
  'skipsUsed': instance.skipsUsed,
  'maxSkips': instance.maxSkips,
  'postponementsUsed': instance.postponementsUsed,
  'nextDeadline': instance.nextDeadline?.toIso8601String(),
};

ChallengeProofModel _$ChallengeProofModelFromJson(Map<String, dynamic> json) =>
    ChallengeProofModel(
      id: ChallengeProofModel._idFromJson(json['_id']),
      imageUrl: json['imageUrl'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ChallengeProofModelToJson(
  ChallengeProofModel instance,
) => <String, dynamic>{
  '_id': instance.id,
  'imageUrl': instance.imageUrl,
  'status': instance.status,
  'createdAt': instance.createdAt.toIso8601String(),
};
