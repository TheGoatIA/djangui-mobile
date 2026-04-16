// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadResponseModel _$UploadResponseModelFromJson(Map<String, dynamic> json) =>
    UploadResponseModel(
      avatarUrl: json['avatarUrl'] as String?,
      documentUrl: json['documentUrl'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$UploadResponseModelToJson(
  UploadResponseModel instance,
) => <String, dynamic>{
  'avatarUrl': instance.avatarUrl,
  'documentUrl': instance.documentUrl,
  'url': instance.url,
};
