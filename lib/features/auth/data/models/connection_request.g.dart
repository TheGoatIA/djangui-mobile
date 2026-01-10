// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionRequest _$ConnectionRequestFromJson(Map<String, dynamic> json) =>
    ConnectionRequest(
      ip: json['ip'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      device: json['device'] as String?,
    );

Map<String, dynamic> _$ConnectionRequestToJson(ConnectionRequest instance) =>
    <String, dynamic>{
      'ip': instance.ip,
      'country': instance.country,
      'city': instance.city,
      'device': instance.device,
    };
