import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'connection_request.g.dart';

@JsonSerializable()
class ConnectionRequest extends Equatable {
  final String? ip;
  final String? country;
  final String? city;
  final String? device;

  const ConnectionRequest({this.ip, this.country, this.city, this.device});

  factory ConnectionRequest.fromJson(Map<String, dynamic> json) =>
      _$ConnectionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectionRequestToJson(this);

  @override
  List<Object?> get props => [ip, country, city, device];
}
