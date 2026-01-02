// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalModel _$GoalModelFromJson(Map<String, dynamic> json) => GoalModel(
      id: json['id'] as String,
      name: json['name'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num).toDouble(),
      deadline: DateTime.parse(json['deadline'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$GoalModelToJson(GoalModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'targetAmount': instance.targetAmount,
      'currentAmount': instance.currentAmount,
      'deadline': instance.deadline.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
