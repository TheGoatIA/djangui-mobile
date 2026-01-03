import 'package:json_annotation/json_annotation.dart';

part 'investment_model.g.dart';

@JsonSerializable()
class InvestmentModel {
  final String id;
  final String name;
  final String type; // 'crypto', 'stock', 'real_estate', 'other'
  final double initialAmount;
  final double currentAmount;
  final double roi; // Percentage
  final DateTime date;
  @JsonKey(defaultValue: '')
  final String notes;

  InvestmentModel({
    required this.id,
    required this.name,
    required this.type,
    required this.initialAmount,
    required this.currentAmount,
    required this.roi,
    required this.date,
    required this.notes,
  });

  factory InvestmentModel.fromJson(Map<String, dynamic> json) =>
      _$InvestmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$InvestmentModelToJson(this);
}
