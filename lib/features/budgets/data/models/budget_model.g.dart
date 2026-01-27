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
        BudgetCategoryModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'allocated': instance.allocated,
      'spent': instance.spent,
      'percentage': instance.percentage,
    };

BudgetModel _$BudgetModelFromJson(Map<String, dynamic> json) => BudgetModel(
      id: BudgetModel._idFromJson(json['_id']),
      period:
          BudgetPeriodModel.fromJson(json['period'] as Map<String, dynamic>),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => BudgetCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAllocated: (json['totalAllocated'] as num).toDouble(),
      totalSpent: (json['totalSpent'] as num).toDouble(),
      status: json['status'] as String,
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
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
