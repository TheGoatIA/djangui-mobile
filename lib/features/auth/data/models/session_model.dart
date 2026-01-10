import 'package:json_annotation/json_annotation.dart';

part 'session_model.g.dart';

@JsonSerializable()
class SessionModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? deviceName;
  final String? browser;
  final String? os;
  final String? ipAddress;
  final String? location;
  final DateTime? lastActive;
  final bool? isCurrent;

  SessionModel({
    this.id,
    this.deviceName,
    this.browser,
    this.os,
    this.ipAddress,
    this.location,
    this.lastActive,
    this.isCurrent = false,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);
  Map<String, dynamic> toJson() => _$SessionModelToJson(this);
}
