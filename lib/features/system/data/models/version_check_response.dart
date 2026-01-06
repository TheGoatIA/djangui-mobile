import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'version_check_response.g.dart';

@JsonSerializable()
class VersionCheckResponse extends Equatable {
  final bool forceUpdate;
  final bool updateAvailable;
  final String latestVersion;
  final String minVersion;
  final String? updateUrl;
  final bool maintenanceMode;
  final String? maintenanceMessage;

  const VersionCheckResponse({
    required this.forceUpdate,
    required this.updateAvailable,
    required this.latestVersion,
    required this.minVersion,
    this.updateUrl,
    this.maintenanceMode = false,
    this.maintenanceMessage,
  });

  factory VersionCheckResponse.fromJson(Map<String, dynamic> json) =>
      _$VersionCheckResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VersionCheckResponseToJson(this);

  @override
  List<Object?> get props => [
    forceUpdate,
    updateAvailable,
    latestVersion,
    minVersion,
    updateUrl,
    maintenanceMode,
    maintenanceMessage,
  ];
}
