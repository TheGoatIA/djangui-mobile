// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'subscription_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$SubscriptionApiService extends SubscriptionApiService {
  _$SubscriptionApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = SubscriptionApiService;

  @override
  Future<Response<BaseListResponse<SubscriptionModel>>> getSubscriptions() {
    final Uri $url = Uri.parse('/subscriptions');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<BaseListResponse<SubscriptionModel>, SubscriptionModel>(
      $request,
    );
  }

  @override
  Future<Response<BaseResponse<SubscriptionModel>>> addSubscription(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/subscriptions');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BaseResponse<SubscriptionModel>, SubscriptionModel>(
      $request,
    );
  }

  @override
  Future<Response<BaseResponse<SubscriptionModel>>> getSubscriptionDetails(
    String id,
  ) {
    final Uri $url = Uri.parse('/subscriptions/${id}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<BaseResponse<SubscriptionModel>, SubscriptionModel>(
      $request,
    );
  }

  @override
  Future<Response<BaseResponse<SubscriptionModel>>> updateSubscription(
    String id,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/subscriptions/${id}');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<BaseResponse<SubscriptionModel>, SubscriptionModel>(
      $request,
    );
  }

  @override
  Future<Response<BaseResponse<dynamic>>> deleteSubscription(String id) {
    final Uri $url = Uri.parse('/subscriptions/${id}');
    final Request $request = Request('DELETE', $url, client.baseUrl);
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }

  @override
  Future<Response<BaseListResponse<SubscriptionSuggestion>>>
  detectSubscriptions() {
    final Uri $url = Uri.parse('/subscriptions/detect');
    final Request $request = Request('POST', $url, client.baseUrl);
    return client
        .send<BaseListResponse<SubscriptionSuggestion>, SubscriptionSuggestion>(
          $request,
        );
  }
}
