import 'package:injectable/injectable.dart';
import '../../../../core/database/database.dart';
import '../models/chat_message_model.dart';

abstract class CoachLocalDataSource {
  Future<List<ChatMessageModel>> getChatHistory();
  Future<void> saveMessage(ChatMessageModel message);
  Future<void> saveMessages(List<ChatMessageModel> messages);
  Future<void> deleteMessage(String id);
  Future<void> clearHistory();
}

@LazySingleton(as: CoachLocalDataSource)
class CoachLocalDataSourceImpl implements CoachLocalDataSource {
  final AppDatabase _database;

  CoachLocalDataSourceImpl(this._database);

  @override
  Future<List<ChatMessageModel>> getChatHistory() async {
    final rows = await _database.select(_database.chatMessages).get();
    return rows
        .map(
          (row) => ChatMessageModel(
            id: row.id,
            text: row.content,
            sender: row.sender,
            timestamp: row.timestamp,
          ),
        )
        .toList();
  }

  @override
  Future<void> saveMessage(ChatMessageModel message) async {
    await _database
        .into(_database.chatMessages)
        .insertOnConflictUpdate(
          ChatMessagesCompanion.insert(
            id: message.id,
            content: message.text,
            sender: message.sender,
            timestamp: message.timestamp,
          ),
        );
  }

  @override
  Future<void> saveMessages(List<ChatMessageModel> messages) async {
    await _database.batch((batch) {
      batch.insertAllOnConflictUpdate(
        _database.chatMessages,
        messages
            .map(
              (message) => ChatMessagesCompanion.insert(
                id: message.id,
                content: message.text,
                sender: message.sender,
                timestamp: message.timestamp,
              ),
            )
            .toList(),
      );
    });
  }

  @override
  Future<void> deleteMessage(String id) async {
    await (_database.delete(
      _database.chatMessages,
    )..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  Future<void> clearHistory() async {
    await _database.delete(_database.chatMessages).go();
  }
}
