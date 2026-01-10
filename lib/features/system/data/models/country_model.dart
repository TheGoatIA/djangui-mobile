import 'package:json_annotation/json_annotation.dart';

part 'country_model.g.dart';

@JsonSerializable()
class CountryModel {
  @JsonKey(name: '_id')
  final String? id;
  final String code;
  final String name;
  final String currency;
  final String currencySymbol;
  final bool isActive;

  CountryModel({
    this.id,
    required this.code,
    required this.name,
    required this.currency,
    required this.currencySymbol,
    this.isActive = true,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      _$CountryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CountryModelToJson(this);
}

@JsonSerializable()
class CountryListResponse {
  final List<CountryModel> countries;

  CountryListResponse({required this.countries});

  factory CountryListResponse.fromJson(Map<String, dynamic> json) =>
      _$CountryListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CountryListResponseToJson(this);
}
