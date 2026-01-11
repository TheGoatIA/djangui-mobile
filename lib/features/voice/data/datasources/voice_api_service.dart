import 'package:chopper/chopper.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/voice_response_model.dart';
import '../../../../core/network/models/base_response.dart';
import 'package:http/http.dart' show MultipartFile;

part 'voice_api_service.chopper.dart';

@ChopperApi()
abstract class VoiceApiService extends ChopperService {
  @Post(path: ApiConstants.voiceProcess)
  @Multipart()
  Future<Response<BaseResponse<VoiceResponseModel>>> processVoice(
    @PartFile('audio') MultipartFile audio,
  );

  static VoiceApiService create(ChopperClient client) =>
      _$VoiceApiService(client);
}
