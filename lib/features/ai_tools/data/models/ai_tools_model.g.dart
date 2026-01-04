// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_tools_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OcrItemModel _$OcrItemModelFromJson(Map<String, dynamic> json) => OcrItemModel(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$OcrItemModelToJson(OcrItemModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
    };

OcrScanResponseModel _$OcrScanResponseModelFromJson(
        Map<String, dynamic> json) =>
    OcrScanResponseModel(
      merchant: json['merchant'] as String,
      total: (json['total'] as num).toDouble(),
      items: (json['items'] as List<dynamic>)
          .map((e) => OcrItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OcrScanResponseModelToJson(
        OcrScanResponseModel instance) =>
    <String, dynamic>{
      'merchant': instance.merchant,
      'total': instance.total,
      'items': instance.items,
    };

SmsParseResponseModel _$SmsParseResponseModelFromJson(
        Map<String, dynamic> json) =>
    SmsParseResponseModel(
      amount: (json['amount'] as num).toDouble(),
      merchant: json['merchant'] as String,
      category: json['category'] as String,
    );

Map<String, dynamic> _$SmsParseResponseModelToJson(
        SmsParseResponseModel instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'merchant': instance.merchant,
      'category': instance.category,
    };

BulkSmsParseResponseModel _$BulkSmsParseResponseModelFromJson(
        Map<String, dynamic> json) =>
    BulkSmsParseResponseModel(
      processed: (json['processed'] as num).toInt(),
      imported: (json['imported'] as num).toInt(),
      failed: (json['failed'] as num).toInt(),
    );

Map<String, dynamic> _$BulkSmsParseResponseModelToJson(
        BulkSmsParseResponseModel instance) =>
    <String, dynamic>{
      'processed': instance.processed,
      'imported': instance.imported,
      'failed': instance.failed,
    };
