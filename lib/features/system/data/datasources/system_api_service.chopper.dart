// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

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
    final Uri $url = Uri.parse('/system/version-check');
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
    return client
        .send<BaseResponse<VersionCheckResponse>, VersionCheckResponse>(
          $request,
        );
  }

  @override
  Future<Response<BaseResponse<PublicSettingsModel>>> getPublicSettings() {
    final Uri $url = Uri.parse('/system/public-settings');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<BaseResponse<PublicSettingsModel>, PublicSettingsModel>(
      $request,
    );
  }

  @override
  Future<Response<BaseResponse<CountryListResponse>>> getCountries() {
    final Uri $url = Uri.parse('/system/countries');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<BaseResponse<CountryListResponse>, CountryListResponse>(
      $request,
    );
  }
}
