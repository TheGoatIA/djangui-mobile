// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoiceResponseModel _$VoiceResponseModelFromJson(Map<String, dynamic> json) =>
    VoiceResponseModel(
      isValid: json['isValid'] as bool,
      confidence: (json['confidence'] as num).toDouble(),
      amount: (json['amount'] as num?)?.toDouble(),
      category: json['category'] as String?,
      merchant: json['merchant'] as String?,
      description: json['description'] as String,
      type: json['type'] as String,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      targetGoal: json['targetGoal'] as String?,
    );

Map<String, dynamic> _$VoiceResponseModelToJson(VoiceResponseModel instance) =>
    <String, dynamic>{
      'isValid': instance.isValid,
      'confidence': instance.confidence,
      'amount': instance.amount,
      'category': instance.category,
      'merchant': instance.merchant,
      'description': instance.description,
      'type': instance.type,
      'date': instance.date?.toIso8601String(),
      'targetGoal': instance.targetGoal,
    };
