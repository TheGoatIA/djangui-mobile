// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'voice_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$VoiceApiService extends VoiceApiService {
  _$VoiceApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = VoiceApiService;

  @override
  Future<Response<BaseResponse<VoiceResponseModel>>> processVoice(
    MultipartFile audio,
  ) {
    final Uri $url = Uri.parse('/voice/process');
    final List<PartValue> $parts = <PartValue>[
      PartValueFile<MultipartFile>('audio', audio),
    ];
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
    );
    return client.send<BaseResponse<VoiceResponseModel>, VoiceResponseModel>(
      $request,
    );
  }
}
