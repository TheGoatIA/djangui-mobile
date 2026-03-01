// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ConfigApiService extends ConfigApiService {
  _$ConfigApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ConfigApiService;

  @override
  Future<Response<BaseResponse<FeatureFlagModel>>> getFeatureFlags() {
    final Uri $url = Uri.parse('/config/features');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client
        .send<BaseResponse<FeatureFlagModel>, FeatureFlagModel>($request);
  }
}
