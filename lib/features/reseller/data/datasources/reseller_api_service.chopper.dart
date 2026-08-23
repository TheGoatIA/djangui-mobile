// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'reseller_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ResellerApiService extends ResellerApiService {
  _$ResellerApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ResellerApiService;

  @override
  Future<Response<BaseResponse<Map<String, dynamic>>>> getDashboardStats() {
    final Uri $url = Uri.parse('/reseller/dashboard');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client
        .send<BaseResponse<Map<String, dynamic>>, Map<String, dynamic>>(
          $request,
        );
  }

  @override
  Future<Response<BaseListResponse<Map<String, dynamic>>>> getAccounts() {
    final Uri $url = Uri.parse('/reseller/accounts');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client
        .send<BaseListResponse<Map<String, dynamic>>, Map<String, dynamic>>(
          $request,
        );
  }

  @override
  Future<Response<BaseResponse<Map<String, dynamic>>>> createAccount(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/reseller/accounts');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client
        .send<BaseResponse<Map<String, dynamic>>, Map<String, dynamic>>(
          $request,
        );
  }

  @override
  Future<Response<BaseResponse<Map<String, dynamic>>>> unlockVault(String id) {
    final Uri $url = Uri.parse('/reseller/accounts/${id}/vault');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client
        .send<BaseResponse<Map<String, dynamic>>, Map<String, dynamic>>(
          $request,
        );
  }

  @override
  Future<Response<BaseResponse<Map<String, dynamic>>>> addSlot(
    String accountId,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/reseller/accounts/${accountId}/slots');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client
        .send<BaseResponse<Map<String, dynamic>>, Map<String, dynamic>>(
          $request,
        );
  }

  @override
  Future<Response<BaseResponse<Map<String, dynamic>>>> deleteSlot(
    String slotId,
  ) {
    final Uri $url = Uri.parse('/reseller/slots/${slotId}');
    final Request $request = Request('DELETE', $url, client.baseUrl);
    return client
        .send<BaseResponse<Map<String, dynamic>>, Map<String, dynamic>>(
          $request,
        );
  }

  @override
  Future<Response<BaseResponse<Map<String, dynamic>>>> deleteAccount(
    String id,
  ) {
    final Uri $url = Uri.parse('/reseller/accounts/${id}');
    final Request $request = Request('DELETE', $url, client.baseUrl);
    return client
        .send<BaseResponse<Map<String, dynamic>>, Map<String, dynamic>>(
          $request,
        );
  }

  @override
  Future<Response<BaseResponse<Map<String, dynamic>>>> recordSlotPayment(
    String slotId,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/reseller/slots/${slotId}/pay');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client
        .send<BaseResponse<Map<String, dynamic>>, Map<String, dynamic>>(
          $request,
        );
  }
}
