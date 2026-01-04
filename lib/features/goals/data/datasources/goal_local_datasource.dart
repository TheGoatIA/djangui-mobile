import 'dart:convert';
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
    return rows.map((row) {
      final participants = List<String>.from(json.decode(row.participants));

      return GoalModel(
        id: row.id,
        name: row.name,
        targetAmount: row.targetAmount,
        currentAmount: row.currentAmount,
        currency: row.currency,
        deadline: row.deadline,
        category: row.category,
        status: row.status,
        isShared: row.isShared,
        participants: participants,
        image: row.image,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );
    }).toList();
  }

  @override
  Future<void> saveGoals(List<GoalModel> goals) async {
    await _database.batch((batch) {
      batch.insertAll(
        _database.goals,
        goals.map((g) => _toCompanion(g)),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  @override
  Future<void> saveGoal(GoalModel goal) async {
    await _database
        .into(_database.goals)
        .insertOnConflictUpdate(_toCompanion(goal));
  }

  GoalsCompanion _toCompanion(GoalModel g) {
    return GoalsCompanion(
      id: Value(g.id),
      name: Value(g.name),
      targetAmount: Value(g.targetAmount),
      currentAmount: Value(g.currentAmount),
      currency: Value(g.currency),
      deadline: Value(g.deadline),
      category: Value(g.category),
      status: Value(g.status),
      isShared: Value(g.isShared),
      participants: Value(json.encode(g.participants)),
      image: Value(g.image),
      createdAt: Value(g.createdAt),
      updatedAt: Value(g.updatedAt),
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
