// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$TransactionApiService extends TransactionApiService {
  _$TransactionApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = TransactionApiService;

  @override
  Future<Response<List<TransactionModel>>> getTransactions() {
    final Uri $url = Uri.parse('/v1/transactions');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<TransactionModel>, TransactionModel>($request);
  }

  @override
  Future<Response<TransactionModel>> createTransaction(
      Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/v1/transactions');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<TransactionModel, TransactionModel>($request);
  }

  @override
  Future<Response<void>> deleteTransaction(String id) {
    final Uri $url = Uri.parse('/v1/transactions/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<void, void>($request);
  }
}
