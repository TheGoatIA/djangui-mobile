import 'dart:convert';
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
    return rows.map((row) {
      final tags = List<String>.from(json.decode(row.tags));
      final metadata = row.metadata != null ? json.decode(row.metadata!) : null;

      return TransactionModel(
        id: row.id,
        amount: row.amount,
        currency: row.currency,
        type: row.type,
        category: row.category,
        subcategory: row.subcategory,
        description: row.description,
        merchant: row.merchant,
        date: row.date,
        status: row.status,
        source: row.source,
        tags: tags,
        isRecurring: row.isRecurring,
        recurringInterval: row.recurringInterval,
        linkedGoalId: row.linkedGoalId,
        metadata: metadata,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );
    }).toList();
  }

  @override
  Future<void> saveTransactions(List<TransactionModel> transactions) async {
    await _database.batch((batch) {
      batch.insertAll(
        _database.transactions,
        transactions.map((t) => _toCompanion(t)),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  @override
  Future<void> saveTransaction(TransactionModel transaction) async {
    await _database
        .into(_database.transactions)
        .insertOnConflictUpdate(_toCompanion(transaction));
  }

  TransactionsCompanion _toCompanion(TransactionModel t) {
    return TransactionsCompanion(
      id: Value(t.id),
      amount: Value(t.amount),
      currency: Value(t.currency),
      type: Value(t.type),
      category: Value(t.category),
      subcategory: Value(t.subcategory),
      description: Value(t.description),
      merchant: Value(t.merchant),
      date: Value(t.date),
      status: Value(t.status),
      source: Value(t.source),
      tags: Value(json.encode(t.tags)),
      isRecurring: Value(t.isRecurring),
      recurringInterval: Value(t.recurringInterval),
      linkedGoalId: Value(t.linkedGoalId),
      metadata: Value(t.metadata != null ? json.encode(t.metadata) : null),
      createdAt: Value(t.createdAt),
      updatedAt: Value(t.updatedAt),
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
