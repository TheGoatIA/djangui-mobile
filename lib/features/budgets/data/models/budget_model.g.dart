// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetPeriodModel _$BudgetPeriodModelFromJson(Map<String, dynamic> json) =>
    BudgetPeriodModel(
      type: json['type'] as String? ?? 'monthly',
      month: (json['month'] as num).toInt(),
      year: (json['year'] as num).toInt(),
    );

Map<String, dynamic> _$BudgetPeriodModelToJson(BudgetPeriodModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'month': instance.month,
      'year': instance.year,
    };

BudgetCategoryModel _$BudgetCategoryModelFromJson(Map<String, dynamic> json) =>
    BudgetCategoryModel(
      name: json['name'] as String,
      allocated: (json['allocated'] as num).toDouble(),
      spent: (json['spent'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$BudgetCategoryModelToJson(
  BudgetCategoryModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'allocated': instance.allocated,
  'spent': instance.spent,
  'percentage': instance.percentage,
};

BudgetModel _$BudgetModelFromJson(Map<String, dynamic> json) => BudgetModel(
  id: BudgetModel._idFromJson(json['_id']),
  period: BudgetPeriodModel.fromJson(json['period'] as Map<String, dynamic>),
  categories: (json['categories'] as List<dynamic>)
      .map((e) => BudgetCategoryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalAllocated: (json['totalAllocated'] as num).toDouble(),
  totalSpent: (json['totalSpent'] as num).toDouble(),
  status: json['status'] as String,
  currency: json['currency'] as String? ?? 'XAF',
  isShared: json['isShared'] as bool? ?? false,
  inviteCode: json['inviteCode'] as String?,
  isOwner: json['isOwner'] as bool? ?? true,
  linkedGoalId: json['linkedGoalId'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$BudgetModelToJson(BudgetModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'period': instance.period,
      'categories': instance.categories,
      'totalAllocated': instance.totalAllocated,
      'totalSpent': instance.totalSpent,
      'status': instance.status,
      'currency': instance.currency,
      'isShared': instance.isShared,
      'inviteCode': instance.inviteCode,
      'isOwner': instance.isOwner,
      'linkedGoalId': instance.linkedGoalId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

BudgetParticipantModel _$BudgetParticipantModelFromJson(
  Map<String, dynamic> json,
) => BudgetParticipantModel(
  id: BudgetModel._idFromJson(json['_id']),
  displayName: json['displayName'] as String,
  joinedAt: json['joinedAt'] == null
      ? null
      : DateTime.parse(json['joinedAt'] as String),
);

Map<String, dynamic> _$BudgetParticipantModelToJson(
  BudgetParticipantModel instance,
) => <String, dynamic>{
  '_id': instance.id,
  'displayName': instance.displayName,
  'joinedAt': instance.joinedAt?.toIso8601String(),
};

BudgetCategoryHistoryPointModel _$BudgetCategoryHistoryPointModelFromJson(
  Map<String, dynamic> json,
) => BudgetCategoryHistoryPointModel(
  month: (json['month'] as num).toInt(),
  year: (json['year'] as num).toInt(),
  allocated: (json['allocated'] as num).toDouble(),
  spent: (json['spent'] as num).toDouble(),
);

Map<String, dynamic> _$BudgetCategoryHistoryPointModelToJson(
  BudgetCategoryHistoryPointModel instance,
) => <String, dynamic>{
  'month': instance.month,
  'year': instance.year,
  'allocated': instance.allocated,
  'spent': instance.spent,
};
