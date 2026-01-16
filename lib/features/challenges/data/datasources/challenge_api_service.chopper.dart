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
  Future<Response<BaseListResponse<ChallengeModel>>> getChallenges() {
    final Uri $url = Uri.parse('/challenges');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<BaseListResponse<ChallengeModel>, ChallengeModel>(
      $request,
    );
  }

  @override
  Future<Response<BaseListResponse<UserChallengeModel>>> getUserChallenges() {
    final Uri $url = Uri.parse('/challenges/my-challenges');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client
        .send<BaseListResponse<UserChallengeModel>, UserChallengeModel>(
          $request,
        );
  }

  @override
  Future<Response<BaseResponse<UserChallengeModel>>> joinChallenge(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/challenges/join');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BaseResponse<UserChallengeModel>, UserChallengeModel>(
      $request,
    );
  }

  @override
  Future<Response<BaseResponse<UserChallengeModel>>> validateWeek(
    String userChallengeId,
    int weekNumber,
    double amount,
    MultipartFile proof,
  ) {
    final Uri $url = Uri.parse('/challenges/validate-week');
    final List<PartValue> $parts = <PartValue>[
      PartValue<String>('userChallengeId', userChallengeId),
      PartValue<int>('weekNumber', weekNumber),
      PartValue<double>('amount', amount),
      PartValueFile<MultipartFile>('proof', proof),
    ];
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
    );
    return client.send<BaseResponse<UserChallengeModel>, UserChallengeModel>(
      $request,
    );
  }

  @override
  Future<Response<BaseResponse<dynamic>>> unjoinChallenge(String id) {
    final Uri $url = Uri.parse('/challenges/${id}');
    final Request $request = Request('DELETE', $url, client.baseUrl);
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }
}
