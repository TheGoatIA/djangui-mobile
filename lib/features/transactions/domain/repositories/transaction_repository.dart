import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/transaction_model.dart';

abstract class TransactionRepository {
  Future<Either<Failure, List<TransactionModel>>> getTransactions({
    bool forceRefresh = false,
  });
  Future<Either<Failure, TransactionModel>> createTransaction(
    TransactionModel transaction,
  );
  Future<Either<Failure, void>> deleteTransaction(String id);
}
