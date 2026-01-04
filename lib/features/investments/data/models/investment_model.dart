import 'package:json_annotation/json_annotation.dart';

part 'investment_model.g.dart';

@JsonSerializable()
class InvestmentHistoryModel {
  final double value;
  final DateTime date;

  InvestmentHistoryModel({required this.value, required this.date});

  factory InvestmentHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$InvestmentHistoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$InvestmentHistoryModelToJson(this);
}

@JsonSerializable()
class InvestmentModel {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'title')
  final String name; // Swagger says 'title', linking to 'name' for internal consistency
  final String type; // 'crypto', 'stock', 'real_estate', 'other'
  final double initialAmount;
  @JsonKey(name: 'currentValue')
  final double currentAmount; // Swagger says 'currentValue'
  final String currency;
  final String status; // 'active', 'closed'
  final List<InvestmentHistoryModel>? history;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  InvestmentModel({
    required this.id,
    required this.name,
    required this.type,
    required this.initialAmount,
    required this.currentAmount,
    this.currency = 'XAF',
    this.status = 'active',
    this.history,
    this.createdAt,
    this.updatedAt,
  });

  factory InvestmentModel.fromJson(Map<String, dynamic> json) =>
      _$InvestmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$InvestmentModelToJson(this);
}
