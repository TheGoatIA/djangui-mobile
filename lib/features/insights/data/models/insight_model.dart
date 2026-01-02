import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'insight_model.g.dart';

@JsonSerializable()
class CategoryDistributionModel extends Equatable {
  final String category;
  final double amount;
  final double percentage;
  final String color;

  const CategoryDistributionModel({
    required this.category,
    required this.amount,
    required this.percentage,
    required this.color,
  });

  factory CategoryDistributionModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryDistributionModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDistributionModelToJson(this);

  @override
  List<Object?> get props => [category, amount, percentage, color];
}

@JsonSerializable()
class SpendingTrendModel extends Equatable {
  final DateTime date;
  final double amount;

  const SpendingTrendModel({required this.date, required this.amount});

  factory SpendingTrendModel.fromJson(Map<String, dynamic> json) =>
      _$SpendingTrendModelFromJson(json);

  Map<String, dynamic> toJson() => _$SpendingTrendModelToJson(this);

  @override
  List<Object?> get props => [date, amount];
}
