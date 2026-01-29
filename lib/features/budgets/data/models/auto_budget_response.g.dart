// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_budget_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutoBudgetEntry _$AutoBudgetEntryFromJson(Map<String, dynamic> json) =>
    AutoBudgetEntry(
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      period: BudgetPeriodModel.fromJson(
        json['period'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$AutoBudgetEntryToJson(AutoBudgetEntry instance) =>
    <String, dynamic>{
      'category': instance.category,
      'amount': instance.amount,
      'period': instance.period,
    };

AutoBudgetResponse _$AutoBudgetResponseFromJson(Map<String, dynamic> json) =>
    AutoBudgetResponse(
      budgets: (json['budgets'] as List<dynamic>)
          .map((e) => AutoBudgetEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      analysis: json['analysis'] as String,
    );

Map<String, dynamic> _$AutoBudgetResponseToJson(AutoBudgetResponse instance) =>
    <String, dynamic>{
      'budgets': instance.budgets,
      'analysis': instance.analysis,
    };
