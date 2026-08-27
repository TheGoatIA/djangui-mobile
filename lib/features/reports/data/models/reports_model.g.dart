// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardReportModel _$DashboardReportModelFromJson(
  Map<String, dynamic> json,
) => DashboardReportModel(
  walletBalance: (json['walletBalance'] as num).toDouble(),
  monthlyIncome: (json['monthlyIncome'] as num).toDouble(),
  totalSpent: (json['totalSpent'] as num).toDouble(),
  savingsRate: (json['savingsRate'] as num).toDouble(),
  currency: json['currency'] as String? ?? 'XAF',
  budgetHealth: json['budgetHealth'] == null
      ? null
      : BudgetHealthModel.fromJson(
          json['budgetHealth'] as Map<String, dynamic>,
        ),
  resteAVivre: json['resteAVivre'] == null
      ? null
      : ResteAVivreModel.fromJson(json['resteAVivre'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DashboardReportModelToJson(
  DashboardReportModel instance,
) => <String, dynamic>{
  'walletBalance': instance.walletBalance,
  'monthlyIncome': instance.monthlyIncome,
  'totalSpent': instance.totalSpent,
  'savingsRate': instance.savingsRate,
  'currency': instance.currency,
  'budgetHealth': instance.budgetHealth,
  'resteAVivre': instance.resteAVivre,
};

ResteAVivreModel _$ResteAVivreModelFromJson(Map<String, dynamic> json) =>
    ResteAVivreModel(
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'XAF',
    );

Map<String, dynamic> _$ResteAVivreModelToJson(ResteAVivreModel instance) =>
    <String, dynamic>{'amount': instance.amount, 'currency': instance.currency};

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
  Map<String, dynamic> json,
) => SpendingAnalysisModel(
  category: json['category'] as String,
  amount: (json['amount'] as num).toDouble(),
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$SpendingAnalysisModelToJson(
  SpendingAnalysisModel instance,
) => <String, dynamic>{
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
  Map<String, dynamic> json,
) => NarrativeReportModel(
  title: json['title'] as String,
  summary: json['summary'] as String,
  topInsights:
      (json['topInsights'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  recommendations:
      (json['recommendations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  tone: json['tone'] as String?,
  healthScore: (json['health_score'] as num?)?.toInt(),
);

Map<String, dynamic> _$NarrativeReportModelToJson(
  NarrativeReportModel instance,
) => <String, dynamic>{
  'title': instance.title,
  'summary': instance.summary,
  'topInsights': instance.topInsights,
  'recommendations': instance.recommendations,
  'tone': instance.tone,
  'health_score': instance.healthScore,
};

ForecastPointModel _$ForecastPointModelFromJson(Map<String, dynamic> json) =>
    ForecastPointModel(
      date: json['date'] as String,
      balance: (json['balance'] as num).toDouble(),
    );

Map<String, dynamic> _$ForecastPointModelToJson(ForecastPointModel instance) =>
    <String, dynamic>{'date': instance.date, 'balance': instance.balance};

ForecastReportModel _$ForecastReportModelFromJson(
  Map<String, dynamic> json,
) => ForecastReportModel(
  forecast:
      (json['forecast'] as List<dynamic>?)
          ?.map((e) => ForecastPointModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  insights:
      (json['insights'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  criticalAlert: json['criticalAlert'] as String?,
);

Map<String, dynamic> _$ForecastReportModelToJson(
  ForecastReportModel instance,
) => <String, dynamic>{
  'forecast': instance.forecast,
  'insights': instance.insights,
  'criticalAlert': instance.criticalAlert,
};

HealthScorePointModel _$HealthScorePointModelFromJson(
  Map<String, dynamic> json,
) => HealthScorePointModel(
  period: json['period'] as String,
  score: (json['score'] as num).toInt(),
);

Map<String, dynamic> _$HealthScorePointModelToJson(
  HealthScorePointModel instance,
) => <String, dynamic>{'period': instance.period, 'score': instance.score};
