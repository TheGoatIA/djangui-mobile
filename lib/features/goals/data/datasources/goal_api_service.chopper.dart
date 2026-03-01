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
  Future<Response<BaseListResponse<GoalModel>>> getGoals() {
    final Uri $url = Uri.parse('/goals');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<BaseListResponse<GoalModel>, GoalModel>($request);
  }

  @override
  Future<Response<BaseResponse<GoalModel>>> createGoal(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/goals');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BaseResponse<GoalModel>, GoalModel>($request);
  }

  @override
  Future<Response<BaseResponse<dynamic>>> deleteGoal(String id) {
    final Uri $url = Uri.parse('/goals/${id}');
    final Request $request = Request('DELETE', $url, client.baseUrl);
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }

  @override
  Future<Response<BaseResponse<GoalModel>>> contributeToGoal(
    String id,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/goals/${id}/contribute');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BaseResponse<GoalModel>, GoalModel>($request);
  }
}
