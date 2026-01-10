import 'package:json_annotation/json_annotation.dart';

part 'country_change_request.g.dart';

@JsonSerializable()
class CountryChangeRequestModel {
  final String? userId;
  final String requestedCountryCode;
  final String status; // pending, approved, rejected
  final String? rejectionReason;
  final DateTime? createdAt;

  CountryChangeRequestModel({
    this.userId,
    required this.requestedCountryCode,
    this.status = 'pending',
    this.rejectionReason,
    this.createdAt,
  });

  factory CountryChangeRequestModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> data = Map<String, dynamic>.from(json);

    // Handle wrapped response where data is in 'request' key
    if (data.containsKey('request') && data['request'] is Map) {
      data = Map<String, dynamic>.from(data['request'] as Map);
    }

    // Handle userId being an object (populated) instead of String
    if (data['userId'] is Map) {
      final userMap = data['userId'] as Map;
      data['userId'] = userMap['id'] ?? userMap['_id'] ?? userMap['userId'];
    }

    // Ensure status is present
    if (data['status'] == null) {
      data['status'] = 'pending';
    }

    // Debug print to trace data
    // debugPrint('Parsing CountryChangeRequestModel: $data');

    return _$CountryChangeRequestModelFromJson(data);
  }

  Map<String, dynamic> toJson() => _$CountryChangeRequestModelToJson(this);
}
