// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$AnalyticsApiService extends AnalyticsApiService {
  _$AnalyticsApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = AnalyticsApiService;

  @override
  Future<Response<dynamic>> trackEvent(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/analytics/events');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<BaseResponse<SessionStartResponse>>> startSession(
      Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/analytics/sessions/start');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<BaseResponse<SessionStartResponse>,
        SessionStartResponse>($request);
  }

  @override
  Future<Response<BaseResponse<dynamic>>> endSession(
      Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/analytics/sessions/end');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }
}
