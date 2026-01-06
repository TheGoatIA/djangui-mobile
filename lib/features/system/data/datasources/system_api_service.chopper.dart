// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$SystemApiService extends SystemApiService {
  _$SystemApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = SystemApiService;

  @override
  Future<Response<BaseResponse<VersionCheckResponse>>> checkVersion(
    String platform,
    String version,
  ) {
    final Uri $url = Uri.parse('/v1/system/version-check');
    final Map<String, dynamic> $params = <String, dynamic>{
      'platform': platform,
      'version': version,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<BaseResponse<VersionCheckResponse>,
        VersionCheckResponse>($request);
  }
}
