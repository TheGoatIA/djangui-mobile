import 'package:drift/drift.dart';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import '../../../../core/database/database.dart';
import '../models/budget_model.dart';

abstract class BudgetLocalDataSource {
  Future<List<BudgetModel>> getBudgets();
  Future<void> saveBudgets(List<BudgetModel> budgets);
  Future<void> saveBudget(BudgetModel budget);
  Future<void> deleteBudget(String id);
  Future<void> clearBudgets();
}

@LazySingleton(as: BudgetLocalDataSource)
class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
  final AppDatabase _database;

  BudgetLocalDataSourceImpl(this._database);

  @override
  Future<List<BudgetModel>> getBudgets() async {
    final rows = await _database.select(_database.budgets).get();
    return rows.map((row) {
      final periodMap = json.decode(row.period) as Map<String, dynamic>;
      final categoriesList = (json.decode(row.categories) as List)
          .map((e) => BudgetCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return BudgetModel(
        id: row.id,
        period: BudgetPeriodModel.fromJson(periodMap),
        categories: categoriesList,
        totalAllocated: row.totalAllocated,
        totalSpent: row.totalSpent,
        status: row.status,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );
    }).toList();
  }

  @override
  Future<void> saveBudgets(List<BudgetModel> budgets) async {
    await _database.batch((batch) {
      batch.insertAll(
        _database.budgets,
        budgets.map((b) => _toCompanion(b)),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  @override
  Future<void> saveBudget(BudgetModel budget) async {
    await _database
        .into(_database.budgets)
        .insertOnConflictUpdate(_toCompanion(budget));
  }

  BudgetsCompanion _toCompanion(BudgetModel b) {
    return BudgetsCompanion(
      id: Value(b.id),
      period: Value(json.encode(b.period.toJson())),
      categories: Value(
        json.encode(b.categories.map((e) => e.toJson()).toList()),
      ),
      totalAllocated: Value(b.totalAllocated),
      totalSpent: Value(b.totalSpent),
      status: Value(b.status),
      createdAt: Value(b.createdAt),
      updatedAt: Value(b.updatedAt),
    );
  }

  @override
  Future<void> deleteBudget(String id) async {
    await (_database.delete(
      _database.budgets,
    )..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> clearBudgets() async {
    await _database.delete(_database.budgets).go();
  }
}
