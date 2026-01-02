// GENERATED CODE - DO NOT MODIFY BY HAND

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
  Future<Response<List<BudgetModel>>> getBudgets() {
    final Uri $url = Uri.parse('/budgets');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<BudgetModel>, BudgetModel>($request);
  }

  @override
  Future<Response<BudgetModel>> createBudget(BudgetModel budget) {
    final Uri $url = Uri.parse('/budgets');
    final $body = budget;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<BudgetModel, BudgetModel>($request);
  }

  @override
  Future<Response<void>> deleteBudget(String id) {
    final Uri $url = Uri.parse('/budgets/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<void, void>($request);
  }
}
