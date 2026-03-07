// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fintech_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$FintechApiService extends FintechApiService {
  _$FintechApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = FintechApiService;

  @override
  Future<Response<BaseResponse<Map<String, dynamic>>>> getBalance() {
    final Uri $url = Uri.parse('/fintech/wallet/balance');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client
        .send<BaseResponse<Map<String, dynamic>>, Map<String, dynamic>>(
          $request,
        );
  }

  @override
  Future<Response<BaseResponse<FintechTransactionsResponseModel>>>
  getTransactions() {
    final Uri $url = Uri.parse('/fintech/wallet/transactions');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<
      BaseResponse<FintechTransactionsResponseModel>,
      FintechTransactionsResponseModel
    >($request);
  }

  @override
  Future<Response<BaseResponse<Map<String, dynamic>>>> withdraw(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/fintech/payout/withdraw');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client
        .send<BaseResponse<Map<String, dynamic>>, Map<String, dynamic>>(
          $request,
        );
  }

  @override
  Future<Response<BaseResponse<Map<String, dynamic>>>> getInvoice(String id) {
    final Uri $url = Uri.parse('/fintech/invoice/${id}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client
        .send<BaseResponse<Map<String, dynamic>>, Map<String, dynamic>>(
          $request,
        );
  }
}
