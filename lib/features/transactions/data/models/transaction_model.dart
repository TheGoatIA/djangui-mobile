import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String? user;
  final double amount;
  final String currency;
  final String type; // 'income', 'expense', 'transfer'
  final String category;
  final String? subcategory;
  final String description;
  final String? merchant;
  final DateTime date;
  final String status; // 'pending', 'completed', 'failed'
  final String? source;
  final List<String> tags;
  final bool isRecurring;
  final String? recurringInterval; // 'daily', 'weekly', 'monthly', 'yearly'
  final String? linkedGoalId;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TransactionModel({
    required this.id,
    this.user,
    required this.amount,
    this.currency = 'XAF',
    required this.type,
    required this.category,
    this.subcategory,
    required this.description,
    this.merchant,
    required this.date,
    this.status = 'completed',
    this.source,
    this.tags = const [],
    this.isRecurring = false,
    this.recurringInterval,
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
    user,
    amount,
    currency,
    type,
    category,
    subcategory,
    description,
    merchant,
    date,
    status,
    source,
    tags,
    isRecurring,
    recurringInterval,
    linkedGoalId,
    metadata,
    createdAt,
    updatedAt,
  ];
}
