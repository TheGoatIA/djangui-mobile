import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'fintech_models.g.dart';

@JsonSerializable()
class FintechTransactionModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final double amount;
  final String type; // 'credit', 'debit', 'deposit', 'withdrawal', 'cash'
  final String description;
  final String status; // 'pending', 'completed', 'failed'
  final DateTime createdAt;
  final String? reference;
  final String? paymentMethod;

  const FintechTransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    required this.status,
    required this.createdAt,
    this.reference,
    this.paymentMethod,
  });

  bool get isRealWalletTransaction {
    return paymentMethod == 'wallet' ||
        paymentMethod == 'notchpay' ||
        paymentMethod == 'stripe';
  }

  factory FintechTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$FintechTransactionModelFromJson(json);
  Map<String, dynamic> toJson() => _$FintechTransactionModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    amount,
    type,
    description,
    status,
    createdAt,
    reference,
    paymentMethod,
  ];
}

@JsonSerializable()
class FintechTransactionsResponseModel extends Equatable {
  final List<FintechTransactionModel> transactions;

  const FintechTransactionsResponseModel({required this.transactions});

  factory FintechTransactionsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => _$FintechTransactionsResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FintechTransactionsResponseModelToJson(this);

  @override
  List<Object?> get props => [transactions];
}

@JsonSerializable()
class InvoiceResponseModel extends Equatable {
  final String pdfUrl;
  final String invoiceNumber;
  final DateTime? createdAt;

  const InvoiceResponseModel({
    required this.pdfUrl,
    required this.invoiceNumber,
    this.createdAt,
  });

  factory InvoiceResponseModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$InvoiceResponseModelToJson(this);

  @override
  List<Object?> get props => [pdfUrl, invoiceNumber, createdAt];
}
