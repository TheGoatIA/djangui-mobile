// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$CoachApiService extends CoachApiService {
  _$CoachApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = CoachApiService;

  @override
  Future<Response<ChatMessageModel>> sendMessage(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/coach/chat');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<ChatMessageModel, ChatMessageModel>($request);
  }
}
