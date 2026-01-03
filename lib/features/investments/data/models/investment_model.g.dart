// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvestmentModel _$InvestmentModelFromJson(Map<String, dynamic> json) =>
    InvestmentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      initialAmount: (json['initialAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num).toDouble(),
      roi: (json['roi'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String? ?? '',
    );

Map<String, dynamic> _$InvestmentModelToJson(InvestmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'initialAmount': instance.initialAmount,
      'currentAmount': instance.currentAmount,
      'roi': instance.roi,
      'date': instance.date.toIso8601String(),
      'notes': instance.notes,
    };
