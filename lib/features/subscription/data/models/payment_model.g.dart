// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) => PaymentModel(
  amount: (json['amount'] as num).toDouble(),
  currency: json['currency'] as String,
  status: json['status'] as String,
  type: json['type'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'currency': instance.currency,
      'status': instance.status,
      'type': instance.type,
      'createdAt': instance.createdAt.toIso8601String(),
    };
