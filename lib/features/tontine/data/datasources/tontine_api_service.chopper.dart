// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'tontine_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$TontineApiService extends TontineApiService {
  _$TontineApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = TontineApiService;

  @override
  Future<Response<BaseResponse<TontineModel>>> createTontine(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/tontines');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BaseResponse<TontineModel>, TontineModel>($request);
  }

  @override
  Future<Response<BaseListResponse<TontineModel>>> getTontines() {
    final Uri $url = Uri.parse('/tontines');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<BaseListResponse<TontineModel>, TontineModel>($request);
  }

  @override
  Future<Response<BaseResponse<TontineModel>>> getTontineDetails(String id) {
    final Uri $url = Uri.parse('/tontines/${id}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<BaseResponse<TontineModel>, TontineModel>($request);
  }

  @override
  Future<Response<BaseResponse<TontineModel>>> updateTontine(
    String id,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/tontines/${id}');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<BaseResponse<TontineModel>, TontineModel>($request);
  }

  @override
  Future<Response<BaseResponse<dynamic>>> deleteTontine(String id) {
    final Uri $url = Uri.parse('/tontines/${id}');
    final Request $request = Request('DELETE', $url, client.baseUrl);
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }

  @override
  Future<Response<BaseResponse<TontineMemberModel>>> joinTontine(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/tontines/join');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BaseResponse<TontineMemberModel>, TontineMemberModel>(
      $request,
    );
  }

  @override
  Future<Response<BaseListResponse<TontineMemberModel>>> getTontineMembers(
    String id,
  ) {
    final Uri $url = Uri.parse('/tontines/${id}/members');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client
        .send<BaseListResponse<TontineMemberModel>, TontineMemberModel>(
          $request,
        );
  }

  @override
  Future<Response<BaseResponse<TontineContributionModel>>> contribute({
    required String tontineId,
    required MultipartFile proofImage,
  }) {
    final Uri $url = Uri.parse('/tontines/contribute');
    final List<PartValue> $parts = <PartValue>[
      PartValue<String>('tontineId', tontineId),
      PartValueFile<MultipartFile>('receipt', proofImage),
    ];
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
    );
    return client
        .send<BaseResponse<TontineContributionModel>, TontineContributionModel>(
          $request,
        );
  }

  @override
  Future<Response<BaseListResponse<TontineMessageModel>>> getTontineMessages(
    String id,
  ) {
    final Uri $url = Uri.parse('/tontines/${id}/messages');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client
        .send<BaseListResponse<TontineMessageModel>, TontineMessageModel>(
          $request,
        );
  }

  @override
  Future<Response<BaseResponse<TontineMessageModel>>> sendMessage(
    String id,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/tontines/${id}/messages');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BaseResponse<TontineMessageModel>, TontineMessageModel>(
      $request,
    );
  }

  @override
  Future<Response<BaseResponse<TontineMessageModel>>> sendVoiceMessage(
    String id, {
    required MultipartFile audioFile,
    required String duration,
  }) {
    final Uri $url = Uri.parse('/tontines/${id}/messages');
    final List<PartValue> $parts = <PartValue>[
      PartValue<String>('duration', duration),
      PartValueFile<MultipartFile>('audio', audioFile),
    ];
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
    );
    return client.send<BaseResponse<TontineMessageModel>, TontineMessageModel>(
      $request,
    );
  }

  @override
  Future<Response<BaseListResponse<TontineContributionModel>>> getContributions(
    String id,
  ) {
    final Uri $url = Uri.parse('/tontines/${id}/contributions');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<
      BaseListResponse<TontineContributionModel>,
      TontineContributionModel
    >($request);
  }

  @override
  Future<Response<BaseResponse<TontineContributionModel>>> validateContribution(
    String tontineId,
    String id,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse(
      '/tontines/${tontineId}/contributions/${id}/validate',
    );
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<BaseResponse<TontineContributionModel>, TontineContributionModel>(
          $request,
        );
  }

  @override
  Future<Response<List<int>>> exportTontine(String id) {
    final Uri $url = Uri.parse('/tontines/${id}/export');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<List<int>, int>($request);
  }

  @override
  Future<Response<BaseResponse<TontineModel>>> startTontine(String id) {
    final Uri $url = Uri.parse('/tontines/${id}/start');
    final Request $request = Request('POST', $url, client.baseUrl);
    return client.send<BaseResponse<TontineModel>, TontineModel>($request);
  }

  @override
  Future<Response<BaseResponse<dynamic>>> removeMember(
    String id,
    String memberId,
  ) {
    final Uri $url = Uri.parse('/tontines/${id}/members/${memberId}');
    final Request $request = Request('DELETE', $url, client.baseUrl);
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }

  @override
  Future<Response<BaseResponse<TontineModel>>> rotateTurn(String id) {
    final Uri $url = Uri.parse('/tontines/${id}/rotation/next');
    final Request $request = Request('POST', $url, client.baseUrl);
    return client.send<BaseResponse<TontineModel>, TontineModel>($request);
  }

  @override
  Future<Response<BaseResponse<TontineMemberModel>>> toggleAutoDebit(
    String id,
    String memberId,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse(
      '/tontines/${id}/members/${memberId}/auto-debit/toggle',
    );
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<BaseResponse<TontineMemberModel>, TontineMemberModel>(
      $request,
    );
  }

  @override
  Future<Response<BaseResponse<TontineMemberModel>>> paySocialFund(String id) {
    final Uri $url = Uri.parse('/tontines/${id}/social-fund/pay');
    final Request $request = Request('POST', $url, client.baseUrl);
    return client.send<BaseResponse<TontineMemberModel>, TontineMemberModel>(
      $request,
    );
  }

  @override
  Future<Response<BaseListResponse<TontineVoteModel>>> getVotes(String id) {
    final Uri $url = Uri.parse('/tontines/${id}/votes');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<BaseListResponse<TontineVoteModel>, TontineVoteModel>(
      $request,
    );
  }

  @override
  Future<Response<BaseResponse<TontineVoteModel>>> createVote(
    String id,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/tontines/${id}/votes');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BaseResponse<TontineVoteModel>, TontineVoteModel>(
      $request,
    );
  }

  @override
  Future<Response<BaseResponse<TontineVoteModel>>> castVote(
    String id,
    String voteId,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/tontines/${id}/votes/${voteId}');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BaseResponse<TontineVoteModel>, TontineVoteModel>(
      $request,
    );
  }
}
