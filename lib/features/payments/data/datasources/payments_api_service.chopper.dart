// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payments_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$PaymentsApiService extends PaymentsApiService {
  _$PaymentsApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = PaymentsApiService;

  @override
  Future<Response<BaseResponse<PaymentInitResponseModel>>> initStripeCheckout(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/payments/checkout/stripe');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client
        .send<BaseResponse<PaymentInitResponseModel>, PaymentInitResponseModel>(
          $request,
        );
  }

  @override
  Future<Response<BaseResponse<PaymentInitResponseModel>>> initNotchPayPayment(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/payments/init/notchpay');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client
        .send<BaseResponse<PaymentInitResponseModel>, PaymentInitResponseModel>(
          $request,
        );
  }
}
