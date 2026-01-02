import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'budget_model.g.dart';

@JsonSerializable()
class BudgetModel extends Equatable {
  final String id;
  final String category;
  final double limitAmount;
  final double spentAmount;
  final DateTime startDate;
  final DateTime endDate;

  const BudgetModel({
    required this.id,
    required this.category,
    required this.limitAmount,
    required this.spentAmount,
    required this.startDate,
    required this.endDate,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetModelFromJson(json);

  Map<String, dynamic> toJson() => _$BudgetModelToJson(this);

  BudgetModel copyWith({
    String? id,
    String? category,
    double? limitAmount,
    double? spentAmount,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      category: category ?? this.category,
      limitAmount: limitAmount ?? this.limitAmount,
      spentAmount: spentAmount ?? this.spentAmount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  List<Object?> get props => [
    id,
    category,
    limitAmount,
    spentAmount,
    startDate,
    endDate,
  ];
}
