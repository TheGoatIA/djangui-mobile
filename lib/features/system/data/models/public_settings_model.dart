import 'package:json_annotation/json_annotation.dart';

part 'public_settings_model.g.dart';

@JsonSerializable()
class PublicSettingsModel {
  @JsonKey(name: 'maintenance_mode')
  final String maintenanceMode;
  @JsonKey(name: 'privacy_policy_url')
  final String privacyPolicyUrl;
  @JsonKey(name: 'terms_of_service_url')
  final String termsOfServiceUrl;

  PublicSettingsModel({
    required this.maintenanceMode,
    required this.privacyPolicyUrl,
    required this.termsOfServiceUrl,
  });

  factory PublicSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$PublicSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PublicSettingsModelToJson(this);
}
