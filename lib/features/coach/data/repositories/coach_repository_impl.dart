import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/coach_local_datasource.dart';
import '../datasources/coach_remote_datasource.dart';
import '../../domain/repositories/coach_repository.dart';
import '../models/chat_message_model.dart';
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
  Future<Either<Failure, ChatMessageModel>> sendMessage(String text) async {
    _logger.info(
      'Envoi d\'un message à l\'assistant Anne.',
      component: 'CoachRepository',
    );
    // Save user message locally first
    final userMessage = ChatMessageModel(
      id: const Uuid().v4(),
      text: text,
      sender: 'user',
      timestamp: DateTime.now(),
    );
    await _localDataSource.saveMessage(userMessage);

    if (await _networkInfo.isConnected) {
      try {
        final aiMessage = await _remoteDataSource.sendMessage(text);
        await _localDataSource.saveMessage(aiMessage);
        _logger.info(
          'Réponse de Anne reçue avec succès.',
          component: 'CoachRepository',
        );
        return Right(aiMessage);
      } catch (e) {
        // Le message n'a jamais atteint le serveur : on retire la copie
        // locale plutôt que de la laisser dans un état ambigu qui serait de
        // toute façon silencieusement effacé au prochain rechargement de
        // l'historique en ligne (qui remplace le cache local par la liste
        // serveur, laquelle ne contient pas ce message).
        await _localDataSource.deleteMessage(userMessage.id);
        _logger.error(
          'Échec de l\'envoi du message au serveur AI',
          error: e,
          component: 'CoachRepository',
        );
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      // Hors-ligne, l'assistant IA ne peut pas répondre en différé (pas de
      // file d'attente de synchronisation pour ce flux) : même logique, on
      // retire le message local plutôt que de le laisser disparaître plus
      // tard sans explication.
      await _localDataSource.deleteMessage(userMessage.id);
      _logger.warning(
        'Impossible de discuter avec Anne hors-ligne.',
        component: 'CoachRepository',
      );
      return Left(NetworkFailure());
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
