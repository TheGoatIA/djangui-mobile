// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_change_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryChangeRequestModel _$CountryChangeRequestModelFromJson(
        Map<String, dynamic> json) =>
    CountryChangeRequestModel(
      userId: json['userId'] as String?,
      requestedCountryCode: json['requestedCountryCode'] as String,
      status: json['status'] as String? ?? 'pending',
      rejectionReason: json['rejectionReason'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CountryChangeRequestModelToJson(
        CountryChangeRequestModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'requestedCountryCode': instance.requestedCountryCode,
      'status': instance.status,
      'rejectionReason': instance.rejectionReason,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
