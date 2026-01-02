import 'package:injectable/injectable.dart';
import 'package:drift/drift.dart';
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
    return rows
        .map(
          (row) => BudgetModel(
            id: row.id,
            category: row.category,
            limitAmount: row.limitAmount,
            spentAmount: row.spentAmount,
            startDate: row.startDate,
            endDate: row.endDate,
          ),
        )
        .toList();
  }

  @override
  Future<void> saveBudgets(List<BudgetModel> budgets) async {
    await _database.batch((batch) {
      batch.insertAll(
        _database.budgets,
        budgets.map(
          (b) => BudgetsCompanion.insert(
            id: b.id,
            category: b.category,
            limitAmount: b.limitAmount,
            spentAmount: b.spentAmount,
            startDate: b.startDate,
            endDate: b.endDate,
          ),
        ),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  @override
  Future<void> saveBudget(BudgetModel budget) async {
    await _database
        .into(_database.budgets)
        .insertOnConflictUpdate(
          BudgetsCompanion.insert(
            id: budget.id,
            category: budget.category,
            limitAmount: budget.limitAmount,
            spentAmount: budget.spentAmount,
            startDate: budget.startDate,
            endDate: budget.endDate,
          ),
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
