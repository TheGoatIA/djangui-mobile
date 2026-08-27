import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/coach_local_datasource.dart';
import '../datasources/coach_remote_datasource.dart';
import '../../domain/repositories/coach_repository.dart';
import '../../domain/entities/coach_send_update.dart';
import '../models/chat_message_model.dart';
import '../models/coach_stream_event.dart';
import '../../../../core/services/log_service.dart';
import '../../../../di/injection.dart';
import 'package:kauri/core/error/error_mapper.dart';

@LazySingleton(as: CoachRepository)
class CoachRepositoryImpl implements CoachRepository {
  final CoachRemoteDataSource _remoteDataSource;
  final CoachLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  CoachRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  LogService get _logger => getIt<LogService>();

  @override
  Future<Either<Failure, List<ChatMessageModel>>> getChatHistory() async {
    _logger.info(
      'Récupération de l\'historique du chat avec Anne...',
      component: 'CoachRepository',
    );
    try {
      // Return local history first if available
      final localHistory = await _localDataSource.getChatHistory();

      if (await _networkInfo.isConnected) {
        _logger.info(
          'Mise à jour de l\'historique depuis le serveur...',
          component: 'CoachRepository',
        );
        // Fetch from remote to update local cache
        final remoteHistory = await _remoteDataSource.getChatHistory();
        // Clear local history before saving remote to prevent duplicates
        // (Local UUIDs do not match server _ids)
        await _localDataSource.clearHistory();
        await _localDataSource.saveMessages(remoteHistory);
        // Fetch again to get the merged/latest list
        final updatedHistory = await _localDataSource.getChatHistory();
        _logger.info(
          '${updatedHistory.length} messages dans l\'historique (Synchronisé).',
          component: 'CoachRepository',
        );
        return Right(updatedHistory);
      } else {
        _logger.info(
          '${localHistory.length} messages dans l\'historique (Hors-ligne).',
          component: 'CoachRepository',
        );
        return Right(localHistory);
      }
    } catch (e) {
      _logger.error(
        'Erreur lors de la récupération de l\'historique du chat',
        error: e,
        component: 'CoachRepository',
      );
      // If error occurs while fetching remote, return local history if available
      final localHistory = await _localDataSource.getChatHistory();
      if (localHistory.isNotEmpty) {
        _logger.warning(
          'Fallback sur l\'historique local suite à une erreur serveur.',
          component: 'CoachRepository',
        );
        return Right(localHistory);
      }
      return Left(ServerFailure(ErrorMapper.safeMessage(e)));
    }
  }

  @override
  Stream<CoachSendUpdate> sendMessageStream(String messageId, String text) async* {
    _logger.info(
      'Envoi d\'un message à l\'assistant Anne (streaming).',
      component: 'CoachRepository',
    );
    // Sauvegardé/mis à jour avec le même id à chaque étape (sending → sent
    // ou failed) : un réessai réutilise cet id, donc la bulle existante est
    // remplacée plutôt que dupliquée.
    final userMessage = ChatMessageModel(
      id: messageId,
      text: text,
      sender: 'user',
      timestamp: DateTime.now(),
      status: 'sending',
    );
    await _localDataSource.saveMessage(userMessage);

    if (!await _networkInfo.isConnected) {
      await _localDataSource.saveMessage(userMessage.copyWith(status: 'failed'));
      _logger.warning(
        'Impossible de discuter avec Anne hors-ligne.',
        component: 'CoachRepository',
      );
      yield CoachSendFailed(NetworkFailure());
      return;
    }

    final buffer = StringBuffer();
    try {
      await for (final event in _remoteDataSource.sendMessageStream(text)) {
        switch (event) {
          case CoachStreamDelta(:final text):
            buffer.write(text);
            yield CoachSendDelta(buffer.toString());
          case CoachStreamDone(:final actions):
            await _localDataSource.saveMessage(
              userMessage.copyWith(status: 'sent'),
            );
            final finalText = buffer.toString();
            await _localDataSource.saveMessage(
              ChatMessageModel(
                id: DateTime.now().microsecondsSinceEpoch.toString(),
                text: finalText,
                sender: 'ai',
                timestamp: DateTime.now(),
                actions: actions,
              ),
            );
            _logger.info(
              'Réponse de Anne reçue avec succès.',
              component: 'CoachRepository',
            );
            yield CoachSendCompleted(finalText, actions);
          case CoachStreamFailure(:final message):
            // Le message n'a jamais abouti : marqué 'failed' plutôt que
            // supprimé, pour permettre un réessai ciblé sur cette bulle
            // précise au lieu d'une snackbar générique.
            await _localDataSource.saveMessage(
              userMessage.copyWith(status: 'failed'),
            );
            _logger.error(
              'Échec de l\'envoi du message au serveur AI',
              error: message,
              component: 'CoachRepository',
            );
            yield CoachSendFailed(ServerFailure(message));
        }
      }
    } catch (e) {
      await _localDataSource.saveMessage(userMessage.copyWith(status: 'failed'));
      _logger.error(
        'Erreur inattendue pendant le streaming du chat',
        error: e,
        component: 'CoachRepository',
      );
      yield CoachSendFailed(ServerFailure(ErrorMapper.safeMessage(e)));
    }
  }

  @override
  Future<Either<Failure, void>> clearHistory() async {
    _logger.info(
      'Suppression de l\'historique du chat.',
      component: 'CoachRepository',
    );
    try {
      await _localDataSource.clearHistory();
      _logger.info(
        'Historique supprimé avec succès.',
        component: 'CoachRepository',
      );
      return const Right(null);
    } catch (e) {
      _logger.error(
        'Erreur lors de la suppression de l\'historique',
        error: e,
        component: 'CoachRepository',
      );
      return Left(CacheFailure());
    }
  }
}
