import 'package:json_annotation/json_annotation.dart';

part 'payment_model.g.dart';

@JsonSerializable()
class PaymentModel {
  final double amount;
  final String currency;
  final String status;
  final String type;
  final DateTime createdAt;

  PaymentModel({
    required this.amount,
    required this.currency,
    required this.status,
    required this.type,
    required this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);
}
