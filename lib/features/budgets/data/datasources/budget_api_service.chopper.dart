// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'budget_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$BudgetApiService extends BudgetApiService {
  _$BudgetApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = BudgetApiService;

  @override
  Future<Response<BaseResponse<BudgetModel>>> getCurrentBudget() {
    final Uri $url = Uri.parse('/budgets/current');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<BaseResponse<BudgetModel>, BudgetModel>($request);
  }

  @override
  Future<Response<BaseListResponse<BudgetModel>>> getBudgets({
    int? year,
    int? month,
  }) {
    final Uri $url = Uri.parse('/budgets');
    final Map<String, dynamic> $params = <String, dynamic>{
      'year': year,
      'month': month,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<BaseListResponse<BudgetModel>, BudgetModel>($request);
  }

  @override
  Future<Response<BaseResponse<BudgetModel>>> createBudget(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/budgets');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BaseResponse<BudgetModel>, BudgetModel>($request);
  }

  @override
  Future<Response<BaseResponse<BudgetModel>>> updateBudget(
    String id,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/budgets/${id}');
    final $body = body;
    final Request $request = Request('PUT', $url, client.baseUrl, body: $body);
    return client.send<BaseResponse<BudgetModel>, BudgetModel>($request);
  }

  @override
  Future<Response<BaseResponse<dynamic>>> deleteBudget(String id) {
    final Uri $url = Uri.parse('/budgets/${id}');
    final Request $request = Request('DELETE', $url, client.baseUrl);
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }

  @override
  Future<Response<BaseResponse<AutoBudgetResponse>>> generateAutoBudget({
    int? month,
    int? year,
  }) {
    final Uri $url = Uri.parse('/premium/auto-budget');
    final Map<String, dynamic> $params = <String, dynamic>{
      'month': month,
      'year': year,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<BaseResponse<AutoBudgetResponse>, AutoBudgetResponse>(
      $request,
    );
  }
}
