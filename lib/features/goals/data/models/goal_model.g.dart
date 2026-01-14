// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalStrategyModel _$GoalStrategyModelFromJson(Map<String, dynamic> json) =>
    GoalStrategyModel(
      type: json['type'] as String,
      details: json['details'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$GoalStrategyModelToJson(GoalStrategyModel instance) =>
    <String, dynamic>{'type': instance.type, 'details': instance.details};

AutoSaveRulesModel _$AutoSaveRulesModelFromJson(Map<String, dynamic> json) =>
    AutoSaveRulesModel(
      enableSurplus: json['enableSurplus'] as bool? ?? false,
      enableRoundup: json['enableRoundup'] as bool? ?? false,
      percentageIncome: (json['percentageIncome'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$AutoSaveRulesModelToJson(AutoSaveRulesModel instance) =>
    <String, dynamic>{
      'enableSurplus': instance.enableSurplus,
      'enableRoundup': instance.enableRoundup,
      'percentageIncome': instance.percentageIncome,
    };

GoalContributionModel _$GoalContributionModelFromJson(
  Map<String, dynamic> json,
) => GoalContributionModel(
  amount: (json['amount'] as num).toDouble(),
  date: DateTime.parse(json['date'] as String),
  note: json['note'] as String?,
);

Map<String, dynamic> _$GoalContributionModelToJson(
  GoalContributionModel instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'date': instance.date.toIso8601String(),
  'note': instance.note,
};

GoalModel _$GoalModelFromJson(Map<String, dynamic> json) => GoalModel(
  id: GoalModel._idFromJson(json['_id']),
  name: json['name'] as String,
  description: json['description'] as String?,
  emoji: json['emoji'] as String?,
  type: json['type'] as String? ?? 'savings',
  targetAmount: (json['targetAmount'] as num).toDouble(),
  currentAmount: (json['currentAmount'] as num?)?.toDouble() ?? 0.0,
  progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
  currency: json['currency'] as String? ?? 'XAF',
  deadline: DateTime.parse(json['deadline'] as String),
  category: json['category'] as String?,
  status: json['status'] as String? ?? 'active',
  priority: json['priority'] as String? ?? 'medium',
  strategy: json['strategy'] == null
      ? const GoalStrategyModel(type: 'custom')
      : GoalStrategyModel.fromJson(json['strategy'] as Map<String, dynamic>),
  autoSaveRules: json['autoSaveRules'] == null
      ? null
      : AutoSaveRulesModel.fromJson(
          json['autoSaveRules'] as Map<String, dynamic>,
        ),
  contributions:
      (json['contributions'] as List<dynamic>?)
          ?.map(
            (e) => GoalContributionModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  isShared: json['isShared'] as bool? ?? false,
  participants:
      (json['participants'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  image: json['image'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$GoalModelToJson(GoalModel instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'emoji': instance.emoji,
  'type': instance.type,
  'targetAmount': instance.targetAmount,
  'currentAmount': instance.currentAmount,
  'progress': instance.progress,
  'currency': instance.currency,
  'deadline': instance.deadline.toIso8601String(),
  'category': instance.category,
  'status': instance.status,
  'priority': instance.priority,
  'strategy': instance.strategy,
  'autoSaveRules': instance.autoSaveRules,
  'contributions': instance.contributions,
  'isShared': instance.isShared,
  'participants': instance.participants,
  'image': instance.image,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
