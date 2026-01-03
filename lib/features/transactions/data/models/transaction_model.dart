import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel extends Equatable {
  final String id;
  final double amount;
  final String type; // 'income' or 'expense'
  final String category;
  final String? subcategory;
  final String description;
  final String? merchant;
  final DateTime date;
  final List<String> tags;
  final bool isRecurring;
  final String? linkedGoalId;

  const TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.category,
    this.subcategory,
    required this.description,
    this.merchant,
    required this.date,
    this.tags = const [],
    this.isRecurring = false,
    this.linkedGoalId,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    amount,
    type,
    category,
    subcategory,
    description,
    merchant,
    date,
    tags,
    isRecurring,
    linkedGoalId,
  ];
}
