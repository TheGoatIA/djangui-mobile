import 'package:chopper/chopper.dart';
import 'package:djangui/core/constants/api_constants.dart';

part 'ai_api_service.chopper.dart';

@ChopperApi()
abstract class AiApiService extends ChopperService {
  @Post(path: ApiConstants.ocrScan)
  @Multipart()
  Future<Response<Map<String, dynamic>>> scanReceipt(
    @PartFile('image') String imagePath,
  );

  @Post(path: ApiConstants.smsParse)
  Future<Response<List<Map<String, dynamic>>>> parseSms(
    @Body() Map<String, dynamic> body,
  );

  @Get(path: ApiConstants.reportNarrative)
  Future<Response<Map<String, dynamic>>> getNarrativeReport();

  static AiApiService create(ChopperClient client) => _$AiApiService(client);
}
