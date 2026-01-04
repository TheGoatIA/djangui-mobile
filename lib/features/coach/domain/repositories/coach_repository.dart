import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/chat_message_model.dart';

abstract class CoachRepository {
  Future<Either<Failure, List<ChatMessageModel>>> getChatHistory();
  Future<Either<Failure, ChatMessageModel>> sendMessage(String text);
  Future<Either<Failure, void>> clearHistory();
}
