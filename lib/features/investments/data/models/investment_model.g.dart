// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvestmentHistoryModel _$InvestmentHistoryModelFromJson(
  Map<String, dynamic> json,
) => InvestmentHistoryModel(
  value: (json['value'] as num).toDouble(),
  date: DateTime.parse(json['date'] as String),
);

Map<String, dynamic> _$InvestmentHistoryModelToJson(
  InvestmentHistoryModel instance,
) => <String, dynamic>{
  'value': instance.value,
  'date': instance.date.toIso8601String(),
};

InvestmentModel _$InvestmentModelFromJson(Map<String, dynamic> json) =>
    InvestmentModel(
      id: json['_id'] as String,
      name: json['title'] as String,
      type: json['type'] as String,
      initialAmount: (json['initialAmount'] as num).toDouble(),
      currentAmount: (json['currentValue'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'XAF',
      status: json['status'] as String? ?? 'active',
      history: (json['history'] as List<dynamic>?)
          ?.map(
            (e) => InvestmentHistoryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$InvestmentModelToJson(InvestmentModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.name,
      'type': instance.type,
      'initialAmount': instance.initialAmount,
      'currentValue': instance.currentAmount,
      'currency': instance.currency,
      'status': instance.status,
      'history': instance.history,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
