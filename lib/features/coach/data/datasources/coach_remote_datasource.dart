import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
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
    print('🌐 [CoachRemote] Sending request to AI coach...');
    final response = await _apiService.ask({'message': text});
    if (response.isSuccessful && response.body != null) {
      print('🌐 [CoachRemote] Success: Received AI response');

      final dynamic body = response.body;
      dynamic data;

      if (body is Map) {
        if (body['success'] == false) {
          throw Exception(body['message'] ?? 'Failed to get coach response');
        }
        data = body['data'];
      } else {
        data = body;
      }

      String responseText = '';
      if (data is Map) {
        responseText =
            data['response'] ?? data['text'] ?? data['content'] ?? '';
      } else if (data is String) {
        responseText = data;
      }

      // If the API doesn't return a full ChatMessageModel, we synthesize it
      return ChatMessageModel(
        id: const Uuid().v4(),
        text: responseText,
        sender: 'ai',
        timestamp: DateTime.now(),
      );
    } else {
      print(
        '🌐 [CoachRemote] Error: ${response.error ?? (response.body is Map ? response.body['message'] : 'Unknown error')}',
      );
      throw Exception('Failed to get coach response');
    }
  }

  @override
  Future<List<ChatMessageModel>> getChatHistory() async {
    print('🌐 [CoachRemote] Fetching chat history...');
    final response = await _apiService.getChatHistory();
    if (response.isSuccessful && response.body != null) {
      final dynamic body = response.body;
      List<dynamic> messageList = [];

      if (body is Map &&
          body['data'] != null &&
          body['data']['messages'] != null) {
        messageList = body['data']['messages'] as List<dynamic>;
      }

      final history = messageList.map((m) {
        final map = m as Map<String, dynamic>;
        return ChatMessageModel(
          id: map['_id'] ?? const Uuid().v4(),
          text: map['content'] ?? '',
          sender: map['role'] == 'model' ? 'ai' : (map['role'] ?? 'user'),
          timestamp: map['timestamp'] != null
              ? DateTime.parse(map['timestamp'])
              : DateTime.now(),
        );
      }).toList();

      print('🌐 [CoachRemote] Success: Received ${history.length} messages');
      return history;
    } else {
      print(
        '🌐 [CoachRemote] Error: ${response.error ?? (response.body is Map ? response.body['message'] : 'Unknown error')}',
      );
      throw Exception('Failed to fetch chat history');
    }
  }
}
