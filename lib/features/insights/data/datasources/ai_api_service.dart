import 'package:chopper/chopper.dart';
import 'package:kauri/core/constants/api_constants.dart';

part 'ai_api_service.chopper.dart';

@ChopperApi()
abstract class AiApiService extends ChopperService {
  @POST(path: ApiConstants.ocrScan)
  @Multipart()
  Future<Response<Map<String, dynamic>>> scanReceipt(
    @PartFile('image') String imagePath,
  );

  /*
  @POST(path: ApiConstants.smsParse)
  Future<Response<List<Map<String, dynamic>>>> parseSms(
    @Body() Map<String, dynamic> body,
  );

  @POST(path: ApiConstants.smsBulkParse)
  Future<Response<Map<String, dynamic>>> bulkParseSms(
    @Body() Map<String, dynamic> body,
  );
*/

  @GET(path: ApiConstants.reportNarrative)
  Future<Response<Map<String, dynamic>>> getNarrativeReport();

  static AiApiService create(ChopperClient client) => _$AiApiService(client);
}

