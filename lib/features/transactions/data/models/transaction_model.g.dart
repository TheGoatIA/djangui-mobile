// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      id: json['_id'] as String,
      userId: json['userId'] as String?,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'XAF',
      type: json['type'] as String,
      category: json['category'] as String,
      subcategory: json['subcategory'] as String?,
      description: json['description'] as String,
      merchant: json['merchant'] as String?,
      location: json['location'] as String?,
      date: DateTime.parse(json['date'] as String),
      status: json['status'] as String? ?? 'completed',
      source: json['source'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      isRecurring: json['isRecurring'] as bool? ?? false,
      recurringFrequency: json['recurringFrequency'] as String?,
      isAutoCategorized: json['isAutoCategorized'] as bool? ?? false,
      categorizationConfidence: (json['categorizationConfidence'] as num?)
          ?.toDouble(),
      receipt: json['receipt'] as String?,
      linkedGoalId: json['linkedGoalId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) {
  final val = <String, dynamic>{'_id': instance.id};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('userId', instance.userId);
  val['amount'] = instance.amount;
  val['currency'] = instance.currency;
  val['type'] = instance.type;
  val['category'] = instance.category;
  writeNotNull('subcategory', instance.subcategory);
  val['description'] = instance.description;
  writeNotNull('merchant', instance.merchant);
  writeNotNull('location', instance.location);
  val['date'] = instance.date.toIso8601String();
  val['status'] = instance.status;
  writeNotNull('source', instance.source);
  val['tags'] = instance.tags;
  val['isRecurring'] = instance.isRecurring;
  writeNotNull('recurringFrequency', instance.recurringFrequency);
  val['isAutoCategorized'] = instance.isAutoCategorized;
  writeNotNull('categorizationConfidence', instance.categorizationConfidence);
  writeNotNull('receipt', instance.receipt);
  writeNotNull('linkedGoalId', instance.linkedGoalId);
  writeNotNull('metadata', instance.metadata);
  writeNotNull('createdAt', instance.createdAt?.toIso8601String());
  writeNotNull('updatedAt', instance.updatedAt?.toIso8601String());
  return val;
}
