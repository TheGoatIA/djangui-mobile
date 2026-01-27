import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'budget_model.dart';

part 'auto_budget_response.g.dart';

@JsonSerializable()
class AutoBudgetEntry extends Equatable {
  final String category;
  final double amount;
  final BudgetPeriodModel period;

  const AutoBudgetEntry({
    required this.category,
    required this.amount,
    required this.period,
  });

  factory AutoBudgetEntry.fromJson(Map<String, dynamic> json) =>
      _$AutoBudgetEntryFromJson(json);
  Map<String, dynamic> toJson() => _$AutoBudgetEntryToJson(this);

  @override
  List<Object?> get props => [category, amount, period];
}

@JsonSerializable()
class AutoBudgetResponse extends Equatable {
  final List<AutoBudgetEntry> budgets;
  final String analysis;

  const AutoBudgetResponse({required this.budgets, required this.analysis});

  factory AutoBudgetResponse.fromJson(Map<String, dynamic> json) =>
      _$AutoBudgetResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AutoBudgetResponseToJson(this);

  @override
  List<Object?> get props => [budgets, analysis];
}
