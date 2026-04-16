import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'upload_model.g.dart';

@JsonSerializable()
class UploadResponseModel extends Equatable {
  @JsonKey(name: 'avatarUrl')
  final String? avatarUrl;
  final String? documentUrl;
  final String? url;

  const UploadResponseModel({this.avatarUrl, this.documentUrl, this.url});

  String get finalUrl => avatarUrl ?? documentUrl ?? url ?? '';

  factory UploadResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UploadResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$UploadResponseModelToJson(this);

  @override
  List<Object?> get props => [avatarUrl, url];
}
