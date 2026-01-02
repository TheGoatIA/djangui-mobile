import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/transaction_local_datasource.dart';
import '../datasources/transaction_remote_datasource.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../models/transaction_model.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource _remoteDataSource;
  final TransactionLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  TransactionRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
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
    if (await _networkInfo.isConnected) {
      try {
        final remoteTransaction = await _remoteDataSource.createTransaction(
          transaction,
        );
        await _localDataSource.saveTransaction(remoteTransaction);
        return Right(remoteTransaction);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      // Offline support could be improved with sync queue
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteTransaction(id);
        await _localDataSource.deleteTransaction(id);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
