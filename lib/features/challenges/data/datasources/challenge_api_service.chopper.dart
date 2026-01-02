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
  Future<Response<ChallengeModel>> joinChallenge(String id) {
    final Uri $url = Uri.parse('/challenges/${id}/join');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<ChallengeModel, ChallengeModel>($request);
  }

  @override
  Future<Response<ChallengeModel>> updateProgress(
    String id,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/challenges/${id}/progress');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<ChallengeModel, ChallengeModel>($request);
  }
}
