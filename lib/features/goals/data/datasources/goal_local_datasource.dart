import 'package:injectable/injectable.dart';
import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../models/goal_model.dart';

abstract class GoalLocalDataSource {
  Future<List<GoalModel>> getGoals();
  Future<void> saveGoals(List<GoalModel> goals);
  Future<void> saveGoal(GoalModel goal);
  Future<void> deleteGoal(String id);
  Future<void> clearGoals();
}

@LazySingleton(as: GoalLocalDataSource)
class GoalLocalDataSourceImpl implements GoalLocalDataSource {
  final AppDatabase _database;

  GoalLocalDataSourceImpl(this._database);

  @override
  Future<List<GoalModel>> getGoals() async {
    final rows = await _database.select(_database.goals).get();
    return rows
        .map(
          (row) => GoalModel(
            id: row.id,
            name: row.name,
            targetAmount: row.targetAmount,
            currentAmount: row.currentAmount,
            deadline: row.deadline,
            createdAt: row.createdAt,
          ),
        )
        .toList();
  }

  @override
  Future<void> saveGoals(List<GoalModel> goals) async {
    await _database.batch((batch) {
      batch.insertAll(
        _database.goals,
        goals.map(
          (g) => GoalsCompanion.insert(
            id: g.id,
            name: g.name,
            targetAmount: g.targetAmount,
            currentAmount: g.currentAmount,
            deadline: g.deadline,
            createdAt: g.createdAt,
          ),
        ),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  @override
  Future<void> saveGoal(GoalModel goal) async {
    await _database
        .into(_database.goals)
        .insertOnConflictUpdate(
          GoalsCompanion.insert(
            id: goal.id,
            name: goal.name,
            targetAmount: goal.targetAmount,
            currentAmount: goal.currentAmount,
            deadline: goal.deadline,
            createdAt: goal.createdAt,
          ),
        );
  }

  @override
  Future<void> deleteGoal(String id) async {
    await (_database.delete(
      _database.goals,
    )..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> clearGoals() async {
    await _database.delete(_database.goals).go();
  }
}
