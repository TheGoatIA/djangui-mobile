import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/transaction_local_datasource.dart';
import '../datasources/transaction_remote_datasource.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../models/transaction_model.dart';
import '../../../../core/database/database.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource _remoteDataSource;
  final TransactionLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final AppDatabase _database;

  TransactionRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
    this._database,
  );

  @override
  Future<Either<Failure, List<TransactionModel>>> getTransactions({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final localTransactions = await _localDataSource.getTransactions();
      if (localTransactions.isNotEmpty) {
        return Right(localTransactions);
      }
    }

    if (await _networkInfo.isConnected) {
      try {
        final remoteTransactions = await _remoteDataSource.getTransactions();
        await _localDataSource.clearTransactions();
        await _localDataSource.saveTransactions(remoteTransactions);
        return Right(remoteTransactions);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      final localTransactions = await _localDataSource.getTransactions();
      if (localTransactions.isNotEmpty) {
        return Right(localTransactions);
      }
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, TransactionModel>> createTransaction(
    TransactionModel transaction,
  ) async {
    // Always save locally first (Optimistic UI)
    await _localDataSource.saveTransaction(transaction);

    if (await _networkInfo.isConnected) {
      try {
        final remoteTransaction = await _remoteDataSource.createTransaction(
          transaction,
        );
        // Update local with remote response (in case of ID change or server-side fields)
        await _localDataSource.saveTransaction(remoteTransaction);
        return Right(remoteTransaction);
      } catch (e) {
        // If server fails but we are connected, it might be a logic error.
        // But for "offline-first" resilience, we could queue it too?
        // Let's treat standard exceptions as reasons to queue if it looks like a network blip.
        // For simplicity: If connected fails, return error. User can retry.
        // ONLY Queue if explicitly OFFLINE.
        return Left(ServerFailure(e.toString()));
      }
    } else {
      // Offline: Queue it
      await _database
          .into(_database.syncRequests)
          .insert(
            SyncRequestsCompanion.insert(
              table: 'transactions',
              action: 'create',
              payload: transactionToJsonString(transaction),
            ),
          );
      return Right(transaction); // Return success so UI updates
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    await _localDataSource.deleteTransaction(id);

    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteTransaction(id);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      // Offline: Queue it
      await _database
          .into(_database.syncRequests)
          .insert(
            SyncRequestsCompanion.insert(
              table: 'transactions',
              action: 'delete',
              payload: '{"id": "$id"}',
            ),
          );
      return const Right(null);
    }
  }

  String transactionToJsonString(TransactionModel t) {
    // Need a helper to avoid circular imports or messy code
    // Assuming TransactionModel has toJson.
    return '{"id": "${t.id}", "amount": ${t.amount}, "type": "${t.type}", "category": "${t.category}", "description": "${t.description}", "date": "${t.date.toIso8601String()}"}';
  }
}
