import 'package:chopper/chopper.dart';
import '../models/chat_message_model.dart';

part 'coach_api_service.chopper.dart';

@ChopperApi(baseUrl: '/coach')
abstract class CoachApiService extends ChopperService {
  static CoachApiService create([ChopperClient? client]) =>
      _$CoachApiService(client);

  @Post(path: '/ask')
  Future<Response<ChatMessageModel>> ask(@Body() Map<String, dynamic> body);

  @Get(path: '/history')
  Future<Response<List<ChatMessageModel>>> getChatHistory();
}
