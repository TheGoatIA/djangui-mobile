// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      category: json['category'] as String,
      subcategory: json['subcategory'] as String?,
      description: json['description'] as String,
      merchant: json['merchant'] as String?,
      date: DateTime.parse(json['date'] as String),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      isRecurring: json['isRecurring'] as bool? ?? false,
      linkedGoalId: json['linkedGoalId'] as String?,
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'type': instance.type,
      'category': instance.category,
      'subcategory': instance.subcategory,
      'description': instance.description,
      'merchant': instance.merchant,
      'date': instance.date.toIso8601String(),
      'tags': instance.tags,
      'isRecurring': instance.isRecurring,
      'linkedGoalId': instance.linkedGoalId,
    };
