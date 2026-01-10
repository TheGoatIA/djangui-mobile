// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryModel _$CountryModelFromJson(Map<String, dynamic> json) => CountryModel(
  id: json['_id'] as String?,
  code: json['code'] as String,
  name: json['name'] as String,
  currency: json['currency'] as String,
  currencySymbol: json['currencySymbol'] as String,
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$CountryModelToJson(CountryModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'currency': instance.currency,
      'currencySymbol': instance.currencySymbol,
      'isActive': instance.isActive,
    };

CountryListResponse _$CountryListResponseFromJson(Map<String, dynamic> json) =>
    CountryListResponse(
      countries: (json['countries'] as List<dynamic>)
          .map((e) => CountryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CountryListResponseToJson(
  CountryListResponse instance,
) => <String, dynamic>{'countries': instance.countries};
