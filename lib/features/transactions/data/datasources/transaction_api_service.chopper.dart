// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

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
  Future<Response<BaseListResponse<TransactionModel>>> getTransactions({
    String? type,
    String? category,
    int? page,
  }) {
    final Uri $url = Uri.parse('/transactions');
    final Map<String, dynamic> $params = <String, dynamic>{
      'type': type,
      'category': category,
      'page': page,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<BaseListResponse<TransactionModel>, TransactionModel>(
      $request,
    );
  }

  @override
  Future<Response<BaseResponse<TransactionModel>>> getTransaction(String id) {
    final Uri $url = Uri.parse('/transactions/${id}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<BaseResponse<TransactionModel>, TransactionModel>(
      $request,
    );
  }

  @override
  Future<Response<BaseResponse<TransactionModel>>> createTransaction(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/transactions');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BaseResponse<TransactionModel>, TransactionModel>(
      $request,
    );
  }

  @override
  Future<Response<BaseResponse<TransactionModel>>> updateTransaction(
    String id,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/transactions/${id}');
    final $body = body;
    final Request $request = Request('PUT', $url, client.baseUrl, body: $body);
    return client.send<BaseResponse<TransactionModel>, TransactionModel>(
      $request,
    );
  }

  @override
  Future<Response<BaseResponse<dynamic>>> createBulkTransaction(String file) {
    final Uri $url = Uri.parse('/transactions/bulk');
    final List<PartValue> $parts = <PartValue>[
      PartValueFile<String>('file', file),
    ];
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
    );
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }

  @override
  Future<Response<BaseResponse<dynamic>>> deleteTransaction(String id) {
    final Uri $url = Uri.parse('/transactions/${id}');
    final Request $request = Request('DELETE', $url, client.baseUrl);
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }
}
