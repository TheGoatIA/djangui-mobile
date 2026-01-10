// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_check_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VersionCheckResponse _$VersionCheckResponseFromJson(
  Map<String, dynamic> json,
) => VersionCheckResponse(
  forceUpdate: json['forceUpdate'] as bool,
  updateAvailable: json['updateAvailable'] as bool,
  latestVersion: json['latestVersion'] as String,
  minVersion: json['minVersion'] as String,
  updateUrl: json['updateUrl'] as String?,
  maintenanceMode: json['maintenanceMode'] as bool? ?? false,
  maintenanceMessage: json['maintenanceMessage'] as String?,
);

Map<String, dynamic> _$VersionCheckResponseToJson(
  VersionCheckResponse instance,
) => <String, dynamic>{
  'forceUpdate': instance.forceUpdate,
  'updateAvailable': instance.updateAvailable,
  'latestVersion': instance.latestVersion,
  'minVersion': instance.minVersion,
  'updateUrl': instance.updateUrl,
  'maintenanceMode': instance.maintenanceMode,
  'maintenanceMessage': instance.maintenanceMessage,
};
