// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_tools_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$AiToolsApiService extends AiToolsApiService {
  _$AiToolsApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = AiToolsApiService;

  @override
  Future<Response<BaseResponse<OcrScanResponseModel>>> scanReceipt(
    String receiptPath,
  ) {
    final Uri $url = Uri.parse('/v1/ocr/scan');
    final List<PartValue> $parts = <PartValue>[
      PartValueFile<String>('receipt', receiptPath),
    ];
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
    );
    return client
        .send<BaseResponse<OcrScanResponseModel>, OcrScanResponseModel>(
          $request,
        );
  }

  @override
  Future<Response<BaseResponse<SmsParseResponseModel>>> parseSms(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/v1/sms/parse');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client
        .send<BaseResponse<SmsParseResponseModel>, SmsParseResponseModel>(
          $request,
        );
  }

  @override
  Future<Response<BaseResponse<BulkSmsParseResponseModel>>> bulkParseSms(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/v1/sms/bulk-parse');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<
      BaseResponse<BulkSmsParseResponseModel>,
      BulkSmsParseResponseModel
    >($request);
  }
}
