// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fintech_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FintechTransactionModel _$FintechTransactionModelFromJson(
  Map<String, dynamic> json,
) => FintechTransactionModel(
  id: json['_id'] as String,
  amount: (json['amount'] as num).toDouble(),
  type: json['type'] as String,
  description: json['description'] as String,
  status: json['status'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  reference: json['reference'] as String?,
  paymentMethod: json['paymentMethod'] as String?,
);

Map<String, dynamic> _$FintechTransactionModelToJson(
  FintechTransactionModel instance,
) => <String, dynamic>{
  '_id': instance.id,
  'amount': instance.amount,
  'type': instance.type,
  'description': instance.description,
  'status': instance.status,
  'createdAt': instance.createdAt.toIso8601String(),
  'reference': instance.reference,
  'paymentMethod': instance.paymentMethod,
};

FintechTransactionsResponseModel _$FintechTransactionsResponseModelFromJson(
  Map<String, dynamic> json,
) => FintechTransactionsResponseModel(
  transactions: (json['transactions'] as List<dynamic>)
      .map((e) => FintechTransactionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$FintechTransactionsResponseModelToJson(
  FintechTransactionsResponseModel instance,
) => <String, dynamic>{'transactions': instance.transactions};

InvoiceResponseModel _$InvoiceResponseModelFromJson(
  Map<String, dynamic> json,
) => InvoiceResponseModel(
  pdfUrl: json['pdfUrl'] as String,
  invoiceNumber: json['invoiceNumber'] as String,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$InvoiceResponseModelToJson(
  InvoiceResponseModel instance,
) => <String, dynamic>{
  'pdfUrl': instance.pdfUrl,
  'invoiceNumber': instance.invoiceNumber,
  'createdAt': instance.createdAt?.toIso8601String(),
};
