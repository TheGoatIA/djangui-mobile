// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserActivity _$UserActivityFromJson(Map<String, dynamic> json) => UserActivity(
  feature: json['feature'] as String,
  action: json['action'] as String,
  details: json['details'] as Map<String, dynamic>?,
  platform: json['platform'] as String?,
  appVersion: json['appVersion'] as String?,
);

Map<String, dynamic> _$UserActivityToJson(UserActivity instance) =>
    <String, dynamic>{
      'feature': instance.feature,
      'action': instance.action,
      'details': instance.details,
      'platform': instance.platform,
      'appVersion': instance.appVersion,
    };

SessionLog _$SessionLogFromJson(Map<String, dynamic> json) => SessionLog(
  deviceId: json['deviceId'] as String?,
  platform: json['platform'] as String?,
  appVersion: json['appVersion'] as String?,
  startTime: json['startTime'] == null
      ? null
      : DateTime.parse(json['startTime'] as String),
  endTime: json['endTime'] == null
      ? null
      : DateTime.parse(json['endTime'] as String),
  durationSeconds: (json['durationSeconds'] as num?)?.toDouble(),
  isActive: json['isActive'] as bool?,
);

Map<String, dynamic> _$SessionLogToJson(SessionLog instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'platform': instance.platform,
      'appVersion': instance.appVersion,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'durationSeconds': instance.durationSeconds,
      'isActive': instance.isActive,
    };

SessionStartResponse _$SessionStartResponseFromJson(
  Map<String, dynamic> json,
) => SessionStartResponse(sessionId: json['sessionId'] as String);

Map<String, dynamic> _$SessionStartResponseToJson(
  SessionStartResponse instance,
) => <String, dynamic>{'sessionId': instance.sessionId};
