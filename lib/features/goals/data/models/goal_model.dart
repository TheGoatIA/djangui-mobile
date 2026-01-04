import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'goal_model.g.dart';

@JsonSerializable()
class GoalModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final String currency;
  final DateTime deadline;
  final String? category;
  final String status; // 'active', 'completed', 'abandoned'
  final bool isShared;
  final List<String> participants;
  final String? image;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const GoalModel({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.currentAmount = 0.0,
    this.currency = 'XAF',
    required this.deadline,
    this.category,
    this.status = 'active',
    this.isShared = false,
    this.participants = const [],
    this.image,
    required this.createdAt,
    this.updatedAt,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) =>
      _$GoalModelFromJson(json);

  Map<String, dynamic> toJson() => _$GoalModelToJson(this);

  GoalModel copyWith({
    String? id,
    String? name,
    double? targetAmount,
    double? currentAmount,
    String? currency,
    DateTime? deadline,
    String? category,
    String? status,
    bool? isShared,
    List<String>? participants,
    String? image,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GoalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      currency: currency ?? this.currency,
      deadline: deadline ?? this.deadline,
      category: category ?? this.category,
      status: status ?? this.status,
      isShared: isShared ?? this.isShared,
      participants: participants ?? this.participants,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    targetAmount,
    currentAmount,
    currency,
    deadline,
    category,
    status,
    isShared,
    participants,
    image,
    createdAt,
    updatedAt,
  ];
}
