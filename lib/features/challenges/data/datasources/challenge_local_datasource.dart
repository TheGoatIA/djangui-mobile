import 'package:injectable/injectable.dart';
import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../models/challenge_model.dart';

abstract class ChallengeLocalDataSource {
  Future<List<ChallengeModel>> getChallenges();
  Future<void> saveChallenges(List<ChallengeModel> challenges);
  Future<void> saveChallenge(ChallengeModel challenge);
  Future<void> clearChallenges();
}

@LazySingleton(as: ChallengeLocalDataSource)
class ChallengeLocalDataSourceImpl implements ChallengeLocalDataSource {
  final AppDatabase _database;

  ChallengeLocalDataSourceImpl(this._database);

  @override
  Future<List<ChallengeModel>> getChallenges() async {
    final rows = await _database.select(_database.challenges).get();
    return rows
        .map(
          (row) => ChallengeModel(
            id: row.id,
            title: row.title,
            description: row.description,
            type: row.type,
            targetValue: row.targetValue,
            currentValue: row.currentValue,
            points: row.points,
            startDate: row.startDate,
            endDate: row.endDate,
            isCompleted: row.isCompleted,
          ),
        )
        .toList();
  }

  @override
  Future<void> saveChallenges(List<ChallengeModel> challenges) async {
    await _database.batch((batch) {
      batch.insertAll(
        _database.challenges,
        challenges.map(
          (c) => ChallengesCompanion.insert(
            id: c.id,
            title: c.title,
            description: c.description,
            type: c.type,
            targetValue: c.targetValue,
            currentValue: c.currentValue,
            points: c.points,
            startDate: c.startDate,
            endDate: c.endDate,
            isCompleted: Value(c.isCompleted),
          ),
        ),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  @override
  Future<void> saveChallenge(ChallengeModel challenge) async {
    await _database
        .into(_database.challenges)
        .insertOnConflictUpdate(
          ChallengesCompanion.insert(
            id: challenge.id,
            title: challenge.title,
            description: challenge.description,
            type: challenge.type,
            targetValue: challenge.targetValue,
            currentValue: challenge.currentValue,
            points: challenge.points,
            startDate: challenge.startDate,
            endDate: challenge.endDate,
            isCompleted: Value(challenge.isCompleted),
          ),
        );
  }

  @override
  Future<void> clearChallenges() async {
    await _database.delete(_database.challenges).go();
  }
}
