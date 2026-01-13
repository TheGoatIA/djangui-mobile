// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicSettingsModel _$PublicSettingsModelFromJson(Map<String, dynamic> json) =>
    PublicSettingsModel(
      maintenanceMode: json['maintenance_mode'] as String?,
      privacyPolicyUrl: json['privacy_policy_url'] as String?,
      termsOfServiceUrl: json['terms_of_service_url'] as String?,
    );

Map<String, dynamic> _$PublicSettingsModelToJson(
        PublicSettingsModel instance) =>
    <String, dynamic>{
      'maintenance_mode': instance.maintenanceMode,
      'privacy_policy_url': instance.privacyPolicyUrl,
      'terms_of_service_url': instance.termsOfServiceUrl,
    };
