import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'challenge_model.g.dart';

@JsonSerializable()
class ChallengeModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String type; // saving, spending
  final double targetValue;
  final double currentValue;
  final int points;
  final DateTime startDate;
  final DateTime endDate;
  final bool isCompleted;

  const ChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetValue,
    required this.currentValue,
    required this.points,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) =>
      _$ChallengeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeModelToJson(this);

  ChallengeModel copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    double? targetValue,
    double? currentValue,
    int? points,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCompleted,
  }) {
    return ChallengeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      points: points ?? this.points,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    type,
    targetValue,
    currentValue,
    points,
    startDate,
    endDate,
    isCompleted,
  ];
}
