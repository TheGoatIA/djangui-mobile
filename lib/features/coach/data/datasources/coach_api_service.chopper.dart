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
  Future<Response<dynamic>> ask(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/coach/ask');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getChatHistory() {
    final Uri $url = Uri.parse('/coach/history');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }
}
