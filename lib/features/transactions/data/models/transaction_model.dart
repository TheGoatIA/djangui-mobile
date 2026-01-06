import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'transaction_model.g.dart';

@JsonSerializable(includeIfNull: false)
class TransactionModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'userId')
  final String? userId;
  final double amount;
  final String currency;
  final String type; // 'income', 'expense', 'transfer'
  final String category;
  final String? subcategory;
  final String description;
  final String? merchant;
  final String? location;
  final DateTime date;
  final String status; // 'pending', 'completed', 'failed'
  final String? source;
  final List<String> tags;
  final bool isRecurring;
  final String? recurringFrequency; // Matches sample 'daily', 'weekly', etc.
  final bool isAutoCategorized;
  final double? categorizationConfidence;
  final String? receipt;
  final String? linkedGoalId;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TransactionModel({
    required this.id,
    this.userId,
    required this.amount,
    this.currency = 'XAF',
    required this.type,
    required this.category,
    this.subcategory,
    required this.description,
    this.merchant,
    this.location,
    required this.date,
    this.status = 'completed',
    this.source,
    this.tags = const [],
    this.isRecurring = false,
    this.recurringFrequency,
    this.isAutoCategorized = false,
    this.categorizationConfidence,
    this.receipt,
    this.linkedGoalId,
    this.metadata,
    this.createdAt,
    this.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    userId,
    amount,
    currency,
    type,
    category,
    subcategory,
    description,
    merchant,
    location,
    date,
    status,
    source,
    tags,
    isRecurring,
    recurringFrequency,
    isAutoCategorized,
    categorizationConfidence,
    receipt,
    linkedGoalId,
    metadata,
    createdAt,
    updatedAt,
  ];
}
