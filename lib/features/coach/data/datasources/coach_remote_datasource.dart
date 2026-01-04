import 'package:injectable/injectable.dart';
import 'coach_api_service.dart';
import '../models/chat_message_model.dart';

abstract class CoachRemoteDataSource {
  Future<ChatMessageModel> sendMessage(String text);
  Future<List<ChatMessageModel>> getChatHistory();
}

@LazySingleton(as: CoachRemoteDataSource)
class CoachRemoteDataSourceImpl implements CoachRemoteDataSource {
  final CoachApiService _apiService;

  CoachRemoteDataSourceImpl(this._apiService);

  @override
  Future<ChatMessageModel> sendMessage(String text) async {
    final response = await _apiService.ask({'message': text});
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(
        response.body?.message ??
            response.error?.toString() ??
            'Failed to get coach response',
      );
    }
  }

  @override
  Future<List<ChatMessageModel>> getChatHistory() async {
    final response = await _apiService.getChatHistory();
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(
        response.body?.message ??
            response.error?.toString() ??
            'Failed to fetch chat history',
      );
    }
  }
}
