// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ChallengeApiService extends ChallengeApiService {
  _$ChallengeApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ChallengeApiService;

  @override
  Future<Response<List<ChallengeModel>>> getChallenges() {
    final Uri $url = Uri.parse('/challenges');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<ChallengeModel>, ChallengeModel>($request);
  }

  @override
  Future<Response<List<dynamic>>> getUserChallenges() {
    final Uri $url = Uri.parse('/challenges/my-challenges');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<dynamic>, List<dynamic>>($request);
  }

  @override
  Future<Response<dynamic>> joinChallenge(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/challenges/join');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> validateWeek(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/challenges/validate-week');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
