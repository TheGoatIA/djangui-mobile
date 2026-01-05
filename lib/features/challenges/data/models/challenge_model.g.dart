// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeModel _$ChallengeModelFromJson(Map<String, dynamic> json) =>
    ChallengeModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      difficulty: json['difficulty'] as String,
      targetAmount: (json['targetAmount'] as num?)?.toDouble(),
      durationDays: (json['durationDays'] as num).toInt(),
      rewardPoints: (json['rewardPoints'] as num).toInt(),
      icon: json['icon'] as String?,
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
    };

UserChallengeModel _$UserChallengeModelFromJson(Map<String, dynamic> json) =>
    UserChallengeModel(
      id: json['_id'] as String,
      status: json['status'] as String,
      progress: (json['progress'] as num).toDouble(),
      currentValue: (json['currentValue'] as num).toDouble(),
      challengeId: json['challengeId'] == null
          ? null
          : ChallengeModel.fromJson(
              json['challengeId'] as Map<String, dynamic>),
      flexibility: json['flexibility'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$UserChallengeModelToJson(UserChallengeModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'status': instance.status,
      'progress': instance.progress,
      'currentValue': instance.currentValue,
      'challengeId': instance.challengeId,
      'flexibility': instance.flexibility,
    };
