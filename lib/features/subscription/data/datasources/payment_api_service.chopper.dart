// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$PaymentApiService extends PaymentApiService {
  _$PaymentApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = PaymentApiService;

  @override
  Future<Response<Map<String, dynamic>>> initializeNotchPay(
      Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/payments/init/notchpay');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> createStripeCheckout(
      Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/payments/checkout/stripe');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}
