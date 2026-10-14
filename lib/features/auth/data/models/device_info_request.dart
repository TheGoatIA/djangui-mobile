import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'device_info_request.g.dart';

@JsonSerializable(includeIfNull: false)
class DeviceInfoRequest extends Equatable {
  final DeviceInfoDetails deviceInfo;
  final String appVersion;
  final String? deviceId;

  const DeviceInfoRequest({
    required this.deviceInfo,
    required this.appVersion,
    this.deviceId,
  });

  factory DeviceInfoRequest.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceInfoRequestToJson(this);

  @override
  List<Object?> get props => [deviceInfo, appVersion, deviceId];
}

@JsonSerializable()
class DeviceInfoDetails extends Equatable {
  final String model;
  final String os;
  final String osVersion;
  final String platform;

  const DeviceInfoDetails({
    required this.model,
    required this.os,
    required this.osVersion,
    required this.platform,
  });

  factory DeviceInfoDetails.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceInfoDetailsToJson(this);

  @override
  List<Object?> get props => [model, os, osVersion, platform];
}
