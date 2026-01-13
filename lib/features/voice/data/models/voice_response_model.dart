import 'package:json_annotation/json_annotation.dart';

part 'voice_response_model.g.dart';

@JsonSerializable()
class VoiceResponseModel {
  final bool isValid;
  final double confidence;
  final double? amount;
  final String? category;
  final String? merchant;
  final String description;
  final String type;
  final DateTime? date;
  final String? targetGoal;

  VoiceResponseModel({
    required this.isValid,
    required this.confidence,
    this.amount,
    this.category,
    this.merchant,
    required this.description,
    required this.type,
    this.date,
    this.targetGoal,
  });

  factory VoiceResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VoiceResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$VoiceResponseModelToJson(this);
}
