// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceInfoRequest _$DeviceInfoRequestFromJson(Map<String, dynamic> json) =>
    DeviceInfoRequest(
      deviceInfo: DeviceInfoDetails.fromJson(
        json['deviceInfo'] as Map<String, dynamic>,
      ),
      appVersion: json['appVersion'] as String,
      deviceId: json['deviceId'] as String?,
    );

Map<String, dynamic> _$DeviceInfoRequestToJson(DeviceInfoRequest instance) =>
    <String, dynamic>{
      'deviceInfo': instance.deviceInfo,
      'appVersion': instance.appVersion,
      'deviceId': ?instance.deviceId,
    };

DeviceInfoDetails _$DeviceInfoDetailsFromJson(Map<String, dynamic> json) =>
    DeviceInfoDetails(
      model: json['model'] as String,
      os: json['os'] as String,
      osVersion: json['osVersion'] as String,
      platform: json['platform'] as String,
    );

Map<String, dynamic> _$DeviceInfoDetailsToJson(DeviceInfoDetails instance) =>
    <String, dynamic>{
      'model': instance.model,
      'os': instance.os,
      'osVersion': instance.osVersion,
      'platform': instance.platform,
    };
