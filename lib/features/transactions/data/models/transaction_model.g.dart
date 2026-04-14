// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      id: TransactionModel._idFromJson(json['_id']),
      userId: TransactionModel._userIdFromJson(json['userId']),
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
      paymentMethod: json['paymentMethod'] as String?,
      fees: (json['fees'] as num?)?.toDouble(),
      externalReference: json['externalReference'] as String?,
      receiptUrl: json['receiptUrl'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': ?instance.userId,
      'amount': instance.amount,
      'currency': instance.currency,
      'type': instance.type,
      'category': instance.category,
      'subcategory': ?instance.subcategory,
      'description': instance.description,
      'merchant': ?instance.merchant,
      'location': ?instance.location,
      'date': instance.date.toIso8601String(),
      'status': instance.status,
      'source': ?instance.source,
      'tags': instance.tags,
      'isRecurring': instance.isRecurring,
      'recurringFrequency': ?instance.recurringFrequency,
      'isAutoCategorized': instance.isAutoCategorized,
      'categorizationConfidence': ?instance.categorizationConfidence,
      'receipt': ?instance.receipt,
      'linkedGoalId': ?instance.linkedGoalId,
      'metadata': ?instance.metadata,
      'paymentMethod': ?instance.paymentMethod,
      'fees': ?instance.fees,
      'externalReference': ?instance.externalReference,
      'receiptUrl': ?instance.receiptUrl,
      'createdAt': ?instance.createdAt?.toIso8601String(),
      'updatedAt': ?instance.updatedAt?.toIso8601String(),
    };
