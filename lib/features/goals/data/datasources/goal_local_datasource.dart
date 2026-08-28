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
      final strategy = row.strategy != null
          ? GoalStrategyModel.fromJson(json.decode(row.strategy!))
          : const GoalStrategyModel(type: 'custom');
      final autoSaveRules = row.autoSaveRules != null
          ? AutoSaveRulesModel.fromJson(json.decode(row.autoSaveRules!))
          : null;
      final contributions = (json.decode(row.contributions) as List)
          .map((c) => GoalContributionModel.fromJson(c as Map<String, dynamic>))
          .toList();

      return GoalModel(
        id: row.id,
        name: row.name,
        description: row.description,
        emoji: row.emoji,
        type: row.type,
        targetAmount: row.targetAmount,
        currentAmount: row.currentAmount,
        progress: row.progress,
        currency: row.currency,
        deadline: row.deadline,
        category: row.category,
        status: row.status,
        priority: row.priority,
        strategy: strategy,
        autoSaveRules: autoSaveRules,
        contributions: contributions,
        isShared: row.isShared,
        inviteCode: row.inviteCode,
        isOwner: row.isOwner,
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
      description: Value(g.description),
      emoji: Value(g.emoji),
      type: Value(g.type),
      targetAmount: Value(g.targetAmount),
      currentAmount: Value(g.currentAmount),
      progress: Value(g.progress),
      currency: Value(g.currency),
      deadline: Value(g.deadline),
      category: Value(g.category),
      status: Value(g.status),
      priority: Value(g.priority),
      strategy: Value(json.encode(g.strategy.toJson())),
      autoSaveRules: Value(
        g.autoSaveRules != null ? json.encode(g.autoSaveRules!.toJson()) : null,
      ),
      contributions: Value(
        json.encode(g.contributions.map((c) => c.toJson()).toList()),
      ),
      isShared: Value(g.isShared),
      inviteCode: Value(g.inviteCode),
      isOwner: Value(g.isOwner),
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
