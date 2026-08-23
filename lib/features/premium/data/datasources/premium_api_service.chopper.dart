// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'premium_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$PremiumApiService extends PremiumApiService {
  _$PremiumApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = PremiumApiService;

  @override
  Future<Response<BaseResponse<Map<String, dynamic>>>> askCoach(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/coach/ask');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client
        .send<BaseResponse<Map<String, dynamic>>, Map<String, dynamic>>(
          $request,
        );
  }

  @override
  Future<Response<BaseResponse<Map<String, dynamic>>>> getAutoBudget() {
    final Uri $url = Uri.parse('/premium/auto-budget');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client
        .send<BaseResponse<Map<String, dynamic>>, Map<String, dynamic>>(
          $request,
        );
  }

  @override
  Future<Response<BaseResponse<Map<String, dynamic>>>> getPremiumReport() {
    final Uri $url = Uri.parse('/premium/report');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client
        .send<BaseResponse<Map<String, dynamic>>, Map<String, dynamic>>(
          $request,
        );
  }

  @override
  Future<Response<BaseResponse<List<dynamic>>>> getPlansConfig() {
    final Uri $url = Uri.parse('/user-subscriptions/plans');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client
        .send<BaseResponse<List<dynamic>>, BaseResponse<List<dynamic>>>(
          $request,
        );
  }
}
