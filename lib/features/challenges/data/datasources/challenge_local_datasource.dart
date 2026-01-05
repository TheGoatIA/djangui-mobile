import 'package:injectable/injectable.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../core/database/database.dart';
import '../models/challenge_model.dart';

abstract class ChallengeLocalDataSource {
  Future<List<ChallengeModel>> getChallenges();
  Future<void> saveChallenges(List<ChallengeModel> challenges);
  Future<void> saveChallenge(ChallengeModel challenge);
  Future<void> clearChallenges();

  // User challenges methods (in-memory cache)
  List<Map<String, dynamic>> getUserChallenges();
  void saveUserChallenges(List<Map<String, dynamic>> userChallenges);
  void clearUserChallenges();
}

@LazySingleton(as: ChallengeLocalDataSource)
class ChallengeLocalDataSourceImpl implements ChallengeLocalDataSource {
  final AppDatabase _database;

  // In-memory cache for user challenges
  List<Map<String, dynamic>> _userChallengesCache = [];

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
            difficulty: row.difficulty,
            targetAmount: row.targetValue,
            durationDays: row.durationDays,
            rewardPoints: row.points,
            icon: row.icon,
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
            targetValue: drift.Value(c.targetAmount),
            currentValue: 0.0,
            points: c.rewardPoints,
            difficulty: drift.Value(c.difficulty),
            durationDays: drift.Value(c.durationDays),
            icon: drift.Value(c.icon),
            startDate: DateTime.now(), // Placeholder
            endDate: DateTime.now().add(Duration(days: c.durationDays)),
          ),
        ),
        mode: drift.InsertMode.insertOrReplace,
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
            targetValue: drift.Value(challenge.targetAmount),
            currentValue: 0.0,
            points: challenge.rewardPoints,
            difficulty: drift.Value(challenge.difficulty),
            durationDays: drift.Value(challenge.durationDays),
            icon: drift.Value(challenge.icon),
            startDate: DateTime.now(), // Placeholder
            endDate: DateTime.now().add(Duration(days: challenge.durationDays)),
          ),
        );
  }

  @override
  Future<void> clearChallenges() async {
    await _database.delete(_database.challenges).go();
  }

  @override
  List<Map<String, dynamic>> getUserChallenges() {
    return List.from(_userChallengesCache);
  }

  @override
  void saveUserChallenges(List<Map<String, dynamic>> userChallenges) {
    _userChallengesCache = List.from(userChallenges);
  }

  @override
  void clearUserChallenges() {
    _userChallengesCache.clear();
  }
}
