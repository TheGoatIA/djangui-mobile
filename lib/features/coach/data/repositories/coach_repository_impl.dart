import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/coach_local_datasource.dart';
import '../datasources/coach_remote_datasource.dart';
import '../../domain/repositories/coach_repository.dart';
import '../models/chat_message_model.dart';

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

  @override
  Future<Either<Failure, List<ChatMessageModel>>> getChatHistory() async {
    try {
      // Return local history first if available
      final localHistory = await _localDataSource.getChatHistory();

      if (await _networkInfo.isConnected) {
        // Fetch from remote to update local cache
        final remoteHistory = await _remoteDataSource.getChatHistory();
        // Save remote history (insertOnConflictUpdate) to merge with local
        await _localDataSource.saveMessages(remoteHistory);
        // Fetch again to get the merged/latest list
        final updatedHistory = await _localDataSource.getChatHistory();
        return Right(updatedHistory);
      } else {
        return Right(localHistory);
      }
    } catch (e) {
      // If error occurs while fetching remote, return local history if available
      final localHistory = await _localDataSource.getChatHistory();
      if (localHistory.isNotEmpty) {
        return Right(localHistory);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatMessageModel>> sendMessage(String text) async {
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
        return Right(aiMessage);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearHistory() async {
    try {
      await _localDataSource.clearHistory();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
