// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$AiApiService extends AiApiService {
  _$AiApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = AiApiService;

  @override
  Future<Response<Map<String, dynamic>>> scanReceipt(String imagePath) {
    final Uri $url = Uri.parse('/ocr/scan');
    final List<PartValue> $parts = <PartValue>[
      PartValueFile<String>(
        'image',
        imagePath,
      )
    ];
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
    );
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> getNarrativeReport() {
    final Uri $url = Uri.parse('/reports/narrative');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}
