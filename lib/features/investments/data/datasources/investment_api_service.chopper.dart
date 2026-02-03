// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investment_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$InvestmentApiService extends InvestmentApiService {
  _$InvestmentApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = InvestmentApiService;

  @override
  Future<Response<BaseListResponse<InvestmentModel>>> getInvestments() {
    final Uri $url = Uri.parse('/investments');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client
        .send<BaseListResponse<InvestmentModel>, InvestmentModel>($request);
  }

  @override
  Future<Response<BaseResponse<InvestmentModel>>> createInvestment(
      Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/investments');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<BaseResponse<InvestmentModel>, InvestmentModel>($request);
  }

  @override
  Future<Response<BaseResponse<dynamic>>> deleteInvestment(String id) {
    final Uri $url = Uri.parse('/investments/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }

  @override
  Future<Response<BaseResponse<dynamic>>> closeInvestment(String id) {
    final Uri $url = Uri.parse('/investments/${id}/close');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }

  @override
  Future<Response<BaseResponse<dynamic>>> updateInvestmentValue(
    String id,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/investments/${id}/value');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }
}
