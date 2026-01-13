import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'reports_model.g.dart';

@JsonSerializable()
class DashboardReportModel extends Equatable {
  final double walletBalance;
  final double monthlyIncome;
  final double totalSpent;
  final double savingsRate;
  final String currency;
  final BudgetHealthModel? budgetHealth;

  const DashboardReportModel({
    required this.walletBalance,
    required this.monthlyIncome,
    required this.totalSpent,
    required this.savingsRate,
    this.currency = 'XAF',
    this.budgetHealth,
  });

  factory DashboardReportModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardReportModelFromJson(json);
  Map<String, dynamic> toJson() => _$DashboardReportModelToJson(this);

  @override
  List<Object?> get props => [
    walletBalance,
    monthlyIncome,
    totalSpent,
    savingsRate,
    currency,
    budgetHealth,
  ];
}

@JsonSerializable()
class BudgetHealthModel extends Equatable {
  final String status;
  final double percentageUsed;

  const BudgetHealthModel({required this.status, required this.percentageUsed});

  factory BudgetHealthModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetHealthModelFromJson(json);
  Map<String, dynamic> toJson() => _$BudgetHealthModelToJson(this);

  @override
  List<Object?> get props => [status, percentageUsed];
}

@JsonSerializable()
class SpendingAnalysisModel extends Equatable {
  final String category;
  final double amount;
  final int count;

  const SpendingAnalysisModel({
    required this.category,
    required this.amount,
    required this.count,
  });

  factory SpendingAnalysisModel.fromJson(Map<String, dynamic> json) =>
      _$SpendingAnalysisModelFromJson(json);
  Map<String, dynamic> toJson() => _$SpendingAnalysisModelToJson(this);

  @override
  List<Object?> get props => [category, amount, count];
}

@JsonSerializable()
class SavingsTrendModel extends Equatable {
  final String period;
  final double income;
  final double expense;
  final double savings;

  const SavingsTrendModel({
    required this.period,
    required this.income,
    required this.expense,
    required this.savings,
  });

  factory SavingsTrendModel.fromJson(Map<String, dynamic> json) =>
      _$SavingsTrendModelFromJson(json);
  Map<String, dynamic> toJson() => _$SavingsTrendModelToJson(this);

  @override
  List<Object?> get props => [period, income, expense, savings];
}

@JsonSerializable()
class NarrativeReportModel extends Equatable {
  final String title;
  final String summary;
  final List<String> topInsights;
  final List<String> recommendations;
  final String? tone;
  @JsonKey(name: 'health_score')
  final int? healthScore;

  const NarrativeReportModel({
    required this.title,
    required this.summary,
    this.topInsights = const [],
    this.recommendations = const [],
    this.tone,
    this.healthScore,
  });

  factory NarrativeReportModel.fromJson(Map<String, dynamic> json) =>
      _$NarrativeReportModelFromJson(json);
  Map<String, dynamic> toJson() => _$NarrativeReportModelToJson(this);

  @override
  List<Object?> get props => [
    title,
    summary,
    topInsights,
    recommendations,
    tone,
    healthScore,
  ];
}
