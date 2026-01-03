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
  Future<Response<List<InvestmentModel>>> getInvestments() {
    final Uri $url = Uri.parse('/investments');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<InvestmentModel>, InvestmentModel>($request);
  }

  @override
  Future<Response<InvestmentModel>> createInvestment(
      Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/investments');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<InvestmentModel, InvestmentModel>($request);
  }

  @override
  Future<Response<void>> deleteInvestment(String id) {
    final Uri $url = Uri.parse('/investments/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<void, void>($request);
  }
}
