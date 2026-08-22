import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/transaction_local_datasource.dart';
import '../datasources/transaction_remote_datasource.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../models/transaction_model.dart';
import '../../../../core/database/database.dart';
import '../../../../core/services/log_service.dart';
import '../../../../di/injection.dart';
import 'package:kauri/core/error/error_mapper.dart';

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

  LogService get _logger => getIt<LogService>();

  @override
  Future<Either<Failure, List<TransactionModel>>> getTransactions({
    bool forceRefresh = false,
  }) async {
    _logger.info(
      'Récupération des transactions (forceRefresh: $forceRefresh)...',
      component: 'TransactionRepository',
    );
    if (!forceRefresh) {
      final localTransactions = await _localDataSource.getTransactions();
      if (localTransactions.isNotEmpty) {
        _logger.info(
          '${localTransactions.length} transactions récupérées du cache local.',
          component: 'TransactionRepository',
        );
        return Right(localTransactions);
      }
    }

    if (await _networkInfo.isConnected) {
      try {
        final remoteTransactions = await _remoteDataSource.getTransactions();
        await _localDataSource.clearTransactions();
        await _localDataSource.saveTransactions(remoteTransactions);
        _logger.info(
          '${remoteTransactions.length} transactions récupérées du serveur.',
          component: 'TransactionRepository',
        );
        return Right(remoteTransactions);
      } catch (e) {
        _logger.error(
          'Erreur lors de la récupération des transactions du serveur',
          error: e,
          component: 'TransactionRepository',
        );
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      final localTransactions = await _localDataSource.getTransactions();
      if (localTransactions.isNotEmpty) {
        _logger.info(
          '${localTransactions.length} transactions récupérées du cache (mode hors-ligne).',
          component: 'TransactionRepository',
        );
        return Right(localTransactions);
      }
      _logger.warning(
        'Aucune transaction trouvée et pas de connexion réseau.',
        component: 'TransactionRepository',
      );
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, TransactionModel>> createTransaction(
    TransactionModel transaction,
  ) async {
    _logger.info(
      'Création d\'une transaction: ${transaction.amount} ${transaction.currency}',
      component: 'TransactionRepository',
    );
    // Always save locally first (Optimistic UI)
    await _localDataSource.saveTransaction(transaction);

    if (await _networkInfo.isConnected) {
      try {
        final remoteTransaction = await _remoteDataSource.createTransaction(
          transaction,
        );
        // If the server returns a different ID, delete the optimistic one
        if (remoteTransaction.id != transaction.id) {
          await _localDataSource.deleteTransaction(transaction.id);
        }
        // Save the remote version
        await _localDataSource.saveTransaction(remoteTransaction);
        _logger.info(
          'Transaction créée avec succès sur le serveur.',
          component: 'TransactionRepository',
          metadata: {'id': remoteTransaction.id},
        );
        return Right(remoteTransaction);
      } catch (e) {
        _logger.error(
          'Échec de la création de la transaction sur le serveur',
          error: e,
          component: 'TransactionRepository',
        );
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      // Offline: Queue it
      _logger.info(
        'Mode hors-ligne: Transaction ajoutée à la file d\'attente de synchronisation.',
        component: 'TransactionRepository',
      );
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
    _logger.info(
      'Suppression de la transaction: $id',
      component: 'TransactionRepository',
    );
    await _localDataSource.deleteTransaction(id);

    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteTransaction(id);
        _logger.info(
          'Transaction supprimée avec succès du serveur.',
          component: 'TransactionRepository',
          metadata: {'id': id},
        );
        return const Right(null);
      } catch (e) {
        _logger.error(
          'Échec de la suppression de la transaction sur le serveur',
          error: e,
          component: 'TransactionRepository',
        );
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      // Offline: Queue it
      _logger.info(
        'Mode hors-ligne: Suppression ajoutée à la file d\'attente de synchronisation.',
        component: 'TransactionRepository',
      );
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
    return jsonEncode(t.toJson());
  }
}
