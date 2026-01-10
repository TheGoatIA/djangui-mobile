// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionModel _$SessionModelFromJson(Map<String, dynamic> json) => SessionModel(
  id: json['_id'] as String?,
  deviceName: json['deviceName'] as String?,
  browser: json['browser'] as String?,
  os: json['os'] as String?,
  ipAddress: json['ipAddress'] as String?,
  location: json['location'] as String?,
  lastActive: json['lastActive'] == null
      ? null
      : DateTime.parse(json['lastActive'] as String),
  isCurrent: json['isCurrent'] as bool? ?? false,
);

Map<String, dynamic> _$SessionModelToJson(SessionModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'deviceName': instance.deviceName,
      'browser': instance.browser,
      'os': instance.os,
      'ipAddress': instance.ipAddress,
      'location': instance.location,
      'lastActive': instance.lastActive?.toIso8601String(),
      'isCurrent': instance.isCurrent,
    };
