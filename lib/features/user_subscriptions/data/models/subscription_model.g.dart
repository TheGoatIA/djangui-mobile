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

Map<String, dynamic> _$SubscriptionModelToJson(SubscriptionModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('userId', instance.userId);
  val['name'] = instance.name;
  writeNotNull('provider', instance.provider);
  val['amount'] = instance.amount;
  val['currency'] = instance.currency;
  val['frequency'] = instance.frequency;
  writeNotNull('category', instance.category);
  writeNotNull('status', instance.status);
  val['nextBillingDate'] = instance.nextBillingDate.toIso8601String();
  writeNotNull('trialEndDate', instance.trialEndDate?.toIso8601String());
  val['remindMe'] = instance.remindMe;
  writeNotNull('createdAt', instance.createdAt?.toIso8601String());
  writeNotNull('updatedAt', instance.updatedAt?.toIso8601String());
  return val;
}

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
