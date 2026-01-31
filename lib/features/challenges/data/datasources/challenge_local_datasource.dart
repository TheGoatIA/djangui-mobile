import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../core/database/database.dart';
import '../models/challenge_model.dart';

abstract class ChallengeLocalDataSource {
  Future<List<ChallengeModel>> getChallenges();
  Future<void> saveChallenges(List<ChallengeModel> challenges);
  Future<void> saveChallenge(ChallengeModel challenge);
  Future<void> clearChallenges();

  // User challenges methods (persistent)
  Future<List<Map<String, dynamic>>> getUserChallenges();
  Future<void> saveUserChallenges(List<Map<String, dynamic>> userChallenges);
  Future<void> clearUserChallenges();
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
  Future<List<Map<String, dynamic>>> getUserChallenges() async {
    final rows = await _database.select(_database.userChallenges).get();
    return rows.map((row) {
      final challengeData = row.challengeData != null
          ? json.decode(row.challengeData!) as Map<String, dynamic>
          : <String, dynamic>{};
      final weeks = row.weeks != null
          ? json.decode(row.weeks!) as List<dynamic>
          : <dynamic>[];

      return {
        '_id': row.id,
        'status': row.status,
        'progress': row.progress,
        'currentValue': row.currentValue,
        'challengeId': challengeData,
        'weeks': weeks,
        'createdAt': row.createdAt?.toIso8601String(),
        'updatedAt': row.updatedAt?.toIso8601String(),
      };
    }).toList();
  }

  @override
  Future<void> saveUserChallenges(
    List<Map<String, dynamic>> userChallenges,
  ) async {
    await _database.batch((batch) {
      batch.insertAllOnConflictUpdate(
        _database.userChallenges,
        userChallenges.map((uc) {
          final id = uc['_id'] ?? uc['id'];
          final challengeId = uc['challengeId'];
          final weeks = uc['weeks'];

          return UserChallengesCompanion.insert(
            id: id.toString(),
            status: drift.Value(uc['status'] ?? 'active'),
            progress: drift.Value((uc['progress'] as num?)?.toDouble() ?? 0.0),
            currentValue: drift.Value(
              (uc['currentValue'] as num?)?.toDouble() ?? 0.0,
            ),
            challengeData: drift.Value(
              challengeId != null ? json.encode(challengeId) : null,
            ),
            weeks: drift.Value(weeks != null ? json.encode(weeks) : null),
            createdAt: drift.Value(
              uc['createdAt'] != null ? DateTime.parse(uc['createdAt']) : null,
            ),
            updatedAt: drift.Value(
              uc['updatedAt'] != null ? DateTime.parse(uc['updatedAt']) : null,
            ),
          );
        }).toList(),
      );
    });
  }

  @override
  Future<void> clearUserChallenges() async {
    await _database.delete(_database.userChallenges).go();
  }
}
