// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$UploadApiService extends UploadApiService {
  _$UploadApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = UploadApiService;

  @override
  Future<Response<BaseResponse<UploadResponseModel>>> uploadReceipt(
    String filePath,
  ) {
    final Uri $url = Uri.parse('/upload/receipt');
    final List<PartValue> $parts = <PartValue>[
      PartValueFile<String>('receipt', filePath),
    ];
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
    );
    return client.send<BaseResponse<UploadResponseModel>, UploadResponseModel>(
      $request,
    );
  }

  @override
  Future<Response<BaseResponse<UploadResponseModel>>> uploadAvatar(
    String filePath,
  ) {
    final Uri $url = Uri.parse('/upload/avatar');
    final List<PartValue> $parts = <PartValue>[
      PartValueFile<String>('avatar', filePath),
    ];
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
    );
    return client.send<BaseResponse<UploadResponseModel>, UploadResponseModel>(
      $request,
    );
  }

  @override
  Future<Response<BaseResponse<UploadResponseModel>>> uploadDocument(
    String filePath,
  ) {
    final Uri $url = Uri.parse('/upload/document');
    final List<PartValue> $parts = <PartValue>[
      PartValueFile<String>('document', filePath),
    ];
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
    );
    return client.send<BaseResponse<UploadResponseModel>, UploadResponseModel>(
      $request,
    );
  }
}
