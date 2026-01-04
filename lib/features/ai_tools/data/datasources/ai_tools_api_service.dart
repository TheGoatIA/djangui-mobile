import 'package:chopper/chopper.dart';
import '../models/ai_tools_model.dart';
import '../../../../core/network/models/base_response.dart';

part 'ai_tools_api_service.chopper.dart';

@ChopperApi()
abstract class AiToolsApiService extends ChopperService {
  static AiToolsApiService create([ChopperClient? client]) =>
      _$AiToolsApiService(client);

  @Post(path: '/v1/ocr/scan')
  @Multipart()
  Future<Response<BaseResponse<OcrScanResponseModel>>> scanReceipt(
    @PartFile('receipt') String receiptPath,
  );

  @Post(path: '/v1/sms/parse')
  Future<Response<BaseResponse<SmsParseResponseModel>>> parseSms(
    @Body() Map<String, dynamic> body,
  );

  @Post(path: '/v1/sms/bulk-parse')
  Future<Response<BaseResponse<BulkSmsParseResponseModel>>> bulkParseSms(
    @Body() Map<String, dynamic> body,
  );
}
