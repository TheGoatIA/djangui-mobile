// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardReportModel _$DashboardReportModelFromJson(
        Map<String, dynamic> json) =>
    DashboardReportModel(
      walletBalance: (json['walletBalance'] as num).toDouble(),
      monthlyIncome: (json['monthlyIncome'] as num).toDouble(),
      totalSpent: (json['totalSpent'] as num).toDouble(),
      savingsRate: (json['savingsRate'] as num).toDouble(),
      budgetHealth: BudgetHealthModel.fromJson(
          json['budgetHealth'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DashboardReportModelToJson(
        DashboardReportModel instance) =>
    <String, dynamic>{
      'walletBalance': instance.walletBalance,
      'monthlyIncome': instance.monthlyIncome,
      'totalSpent': instance.totalSpent,
      'savingsRate': instance.savingsRate,
      'budgetHealth': instance.budgetHealth,
    };

BudgetHealthModel _$BudgetHealthModelFromJson(Map<String, dynamic> json) =>
    BudgetHealthModel(
      status: json['status'] as String,
      percentageUsed: (json['percentageUsed'] as num).toDouble(),
    );

Map<String, dynamic> _$BudgetHealthModelToJson(BudgetHealthModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'percentageUsed': instance.percentageUsed,
    };

SpendingAnalysisModel _$SpendingAnalysisModelFromJson(
        Map<String, dynamic> json) =>
    SpendingAnalysisModel(
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$SpendingAnalysisModelToJson(
        SpendingAnalysisModel instance) =>
    <String, dynamic>{
      'category': instance.category,
      'amount': instance.amount,
      'count': instance.count,
    };

SavingsTrendModel _$SavingsTrendModelFromJson(Map<String, dynamic> json) =>
    SavingsTrendModel(
      period: json['period'] as String,
      income: (json['income'] as num).toDouble(),
      expense: (json['expense'] as num).toDouble(),
      savings: (json['savings'] as num).toDouble(),
    );

Map<String, dynamic> _$SavingsTrendModelToJson(SavingsTrendModel instance) =>
    <String, dynamic>{
      'period': instance.period,
      'income': instance.income,
      'expense': instance.expense,
      'savings': instance.savings,
    };

NarrativeReportModel _$NarrativeReportModelFromJson(
        Map<String, dynamic> json) =>
    NarrativeReportModel(
      title: json['title'] as String,
      summary: json['summary'] as String,
      healthScore: (json['health_score'] as num).toInt(),
    );

Map<String, dynamic> _$NarrativeReportModelToJson(
        NarrativeReportModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'summary': instance.summary,
      'health_score': instance.healthScore,
    };
