import 'package:json_annotation/json_annotation.dart';

part 'badge_model.g.dart';

@JsonSerializable()
class BadgeModel {
  final String name;
  final String icon;
  final DateTime awardedAt;

  BadgeModel({required this.name, required this.icon, required this.awardedAt});

  factory BadgeModel.fromJson(Map<String, dynamic> json) =>
      _$BadgeModelFromJson(json);
  Map<String, dynamic> toJson() => _$BadgeModelToJson(this);
}
