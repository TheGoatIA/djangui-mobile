// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$GoalApiService extends GoalApiService {
  _$GoalApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = GoalApiService;

  @override
  Future<Response<List<GoalModel>>> getGoals() {
    final Uri $url = Uri.parse('/goals');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<GoalModel>, GoalModel>($request);
  }

  @override
  Future<Response<GoalModel>> createGoal(GoalModel goal) {
    final Uri $url = Uri.parse('/goals');
    final $body = goal;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<GoalModel, GoalModel>($request);
  }

  @override
  Future<Response<void>> deleteGoal(String id) {
    final Uri $url = Uri.parse('/goals/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<void, void>($request);
  }

  @override
  Future<Response<GoalModel>> updateGoalAmount(
    String id,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/goals/${id}');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<GoalModel, GoalModel>($request);
  }
}
