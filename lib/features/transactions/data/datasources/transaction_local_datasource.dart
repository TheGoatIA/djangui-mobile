import 'package:injectable/injectable.dart';
import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getTransactions();
  Future<void> saveTransactions(List<TransactionModel> transactions);
  Future<void> saveTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Future<void> clearTransactions();
}

@LazySingleton(as: TransactionLocalDataSource)
class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final AppDatabase _database;

  TransactionLocalDataSourceImpl(this._database);

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final rows = await _database.select(_database.transactions).get();
    return rows
        .map(
          (row) => TransactionModel(
            id: row.id,
            amount: row.amount,
            type: row.type,
            category: row.category,
            description: row.description,
            date: row.date,
          ),
        )
        .toList();
  }

  @override
  Future<void> saveTransactions(List<TransactionModel> transactions) async {
    await _database.batch((batch) {
      batch.insertAll(
        _database.transactions,
        transactions.map(
          (t) => TransactionsCompanion.insert(
            id: t.id,
            amount: t.amount,
            type: t.type,
            category: t.category,
            description: t.description,
            date: t.date,
          ),
        ),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  @override
  Future<void> saveTransaction(TransactionModel transaction) async {
    await _database
        .into(_database.transactions)
        .insertOnConflictUpdate(
          TransactionsCompanion.insert(
            id: transaction.id,
            amount: transaction.amount,
            type: transaction.type,
            category: transaction.category,
            description: transaction.description,
            date: transaction.date,
          ),
        );
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await (_database.delete(
      _database.transactions,
    )..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> clearTransactions() async {
    await _database.delete(_database.transactions).go();
  }
}
