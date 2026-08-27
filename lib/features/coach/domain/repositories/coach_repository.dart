import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/chat_message_model.dart';
import '../entities/coach_send_update.dart';

abstract class CoachRepository {
  Future<Either<Failure, List<ChatMessageModel>>> getChatHistory();

  /// [messageId] est l'id du message utilisateur optimiste déjà affiché par
  /// le Bloc — réutilisé tel quel (pas régénéré) pour qu'un réessai après
  /// échec (même id) remplace la bulle existante au lieu d'en créer une
  /// nouvelle.
  Stream<CoachSendUpdate> sendMessageStream(String messageId, String text);

  Future<Either<Failure, void>> clearHistory();
}
