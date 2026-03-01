// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insight_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryDistributionModel _$CategoryDistributionModelFromJson(
  Map<String, dynamic> json,
) => CategoryDistributionModel(
  category: json['category'] as String,
  amount: (json['amount'] as num).toDouble(),
  percentage: (json['percentage'] as num).toDouble(),
  color: json['color'] as String,
);

Map<String, dynamic> _$CategoryDistributionModelToJson(
  CategoryDistributionModel instance,
) => <String, dynamic>{
  'category': instance.category,
  'amount': instance.amount,
  'percentage': instance.percentage,
  'color': instance.color,
};

SpendingTrendModel _$SpendingTrendModelFromJson(Map<String, dynamic> json) =>
    SpendingTrendModel(
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$SpendingTrendModelToJson(SpendingTrendModel instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'amount': instance.amount,
    };
