// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) =>
    SubscriptionModel(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      name: json['name'] as String,
      provider: json['provider'] as String?,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      frequency: json['frequency'] as String,
      category: json['category'] as String?,
      status: json['status'] as String?,
      nextBillingDate: DateTime.parse(json['nextBillingDate'] as String),
      trialEndDate: json['trialEndDate'] == null
          ? null
          : DateTime.parse(json['trialEndDate'] as String),
      remindMe: json['remindMe'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SubscriptionModelToJson(SubscriptionModel instance) =>
    <String, dynamic>{
      '_id': ?instance.id,
      'userId': ?instance.userId,
      'name': instance.name,
      'provider': ?instance.provider,
      'amount': instance.amount,
      'currency': instance.currency,
      'frequency': instance.frequency,
      'category': ?instance.category,
      'status': ?instance.status,
      'nextBillingDate': instance.nextBillingDate.toIso8601String(),
      'trialEndDate': ?instance.trialEndDate?.toIso8601String(),
      'remindMe': instance.remindMe,
      'createdAt': ?instance.createdAt?.toIso8601String(),
      'updatedAt': ?instance.updatedAt?.toIso8601String(),
    };

SubscriptionSuggestion _$SubscriptionSuggestionFromJson(
  Map<String, dynamic> json,
) => SubscriptionSuggestion(
  name: json['name'] as String,
  amount: (json['amount'] as num).toDouble(),
  frequency: json['frequency'] as String,
  confidence: (json['confidence'] as num).toDouble(),
  detectedFrom: json['detectedFrom'] as String?,
);

Map<String, dynamic> _$SubscriptionSuggestionToJson(
  SubscriptionSuggestion instance,
) => <String, dynamic>{
  'name': instance.name,
  'amount': instance.amount,
  'frequency': instance.frequency,
  'confidence': instance.confidence,
  'detectedFrom': instance.detectedFrom,
};
