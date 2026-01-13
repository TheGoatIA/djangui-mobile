import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'analytics_models.g.dart';

@JsonSerializable()
class UserActivity extends Equatable {
  final String feature;
  final String action;
  final Map<String, dynamic>? details;
  final String? platform;
  final String? appVersion;

  const UserActivity({
    required this.feature,
    required this.action,
    this.details,
    this.platform,
    this.appVersion,
  });

  factory UserActivity.fromJson(Map<String, dynamic> json) =>
      _$UserActivityFromJson(json);

  Map<String, dynamic> toJson() => _$UserActivityToJson(this);

  @override
  List<Object?> get props => [feature, action, details, platform, appVersion];
}

@JsonSerializable()
class SessionLog extends Equatable {
  final String? deviceId;
  final String? platform;
  final String? appVersion;
  final DateTime? startTime;
  final DateTime? endTime;
  final double? durationSeconds;
  final bool? isActive;

  const SessionLog({
    this.deviceId,
    this.platform,
    this.appVersion,
    this.startTime,
    this.endTime,
    this.durationSeconds,
    this.isActive,
  });

  factory SessionLog.fromJson(Map<String, dynamic> json) =>
      _$SessionLogFromJson(json);

  Map<String, dynamic> toJson() => _$SessionLogToJson(this);

  @override
  List<Object?> get props => [
    deviceId,
    platform,
    appVersion,
    startTime,
    endTime,
    durationSeconds,
    isActive,
  ];
}

@JsonSerializable()
class SessionStartResponse extends Equatable {
  final String sessionId;

  const SessionStartResponse({required this.sessionId});

  factory SessionStartResponse.fromJson(Map<String, dynamic> json) =>
      _$SessionStartResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SessionStartResponseToJson(this);

  @override
  List<Object?> get props => [sessionId];
}
