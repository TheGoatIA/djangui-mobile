// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentInitResponseModel _$PaymentInitResponseModelFromJson(
        Map<String, dynamic> json) =>
    PaymentInitResponseModel(
      url: json['url'] as String,
      reference: json['reference'] as String,
    );

Map<String, dynamic> _$PaymentInitResponseModelToJson(
        PaymentInitResponseModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'reference': instance.reference,
    };
