import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable(includeIfNull: false)
class LoginRequest {
  final String email;
  final String password;
  final String? deviceId;
  final Map<String, dynamic>? deviceInfo;
  final String? appVersion;

  LoginRequest({
    required this.email,
    required this.password,
    this.deviceId,
    this.deviceInfo,
    this.appVersion,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
