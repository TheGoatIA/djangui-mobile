import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'budget_model.g.dart';

@JsonSerializable()
class BudgetPeriodModel extends Equatable {
  final String type; // 'monthly', 'yearly'
  final int month;
  final int year;

  const BudgetPeriodModel({
    required this.type,
    required this.month,
    required this.year,
  });

  factory BudgetPeriodModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetPeriodModelFromJson(json);
  Map<String, dynamic> toJson() => _$BudgetPeriodModelToJson(this);

  @override
  List<Object?> get props => [type, month, year];
}

@JsonSerializable()
class BudgetCategoryModel extends Equatable {
  final String name;
  final double allocated;
  final double spent;
  final double percentage;

  const BudgetCategoryModel({
    required this.name,
    required this.allocated,
    required this.spent,
    required this.percentage,
  });

  factory BudgetCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetCategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$BudgetCategoryModelToJson(this);

  @override
  List<Object?> get props => [name, allocated, spent, percentage];
}

@JsonSerializable()
class BudgetModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final BudgetPeriodModel period;
  final List<BudgetCategoryModel> categories;
  final double totalAllocated;
  final double totalSpent;
  final String status; // 'active', 'completed', 'exceeded'
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BudgetModel({
    required this.id,
    required this.period,
    required this.categories,
    required this.totalAllocated,
    required this.totalSpent,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetModelFromJson(json);
  Map<String, dynamic> toJson() => _$BudgetModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    period,
    categories,
    totalAllocated,
    totalSpent,
    status,
    createdAt,
    updatedAt,
  ];
}
