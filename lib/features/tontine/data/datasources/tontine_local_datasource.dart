import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/database.dart';
import '../models/tontine_model.dart';

abstract class TontineLocalDataSource {
  Future<List<TontineModel>> getTontines();
  Future<void> saveTontines(List<TontineModel> tontines);
  Future<void> saveTontine(TontineModel tontine);
  Future<void> deleteTontine(String id);

  Future<List<TontineMemberModel>> getTontineMembers(String tontineId);
  Future<void> saveTontineMembers(
    String tontineId,
    List<TontineMemberModel> members,
  );

  Future<List<TontineMessageModel>> getTontineMessages(String tontineId);
  Future<void> saveTontineMessages(
    String tontineId,
    List<TontineMessageModel> messages,
  );
  Future<void> saveTontineMessage(TontineMessageModel message);
  Future<void> deleteTontineMessage(String id);

  Future<List<TontineContributionModel>> getTontineContributions(
    String tontineId,
  );
  Future<void> saveTontineContributions(
    String tontineId,
    List<TontineContributionModel> contributions,
  );
}

@LazySingleton(as: TontineLocalDataSource)
class TontineLocalDataSourceImpl implements TontineLocalDataSource {
  final AppDatabase _db;

  TontineLocalDataSourceImpl(this._db);

  @override
  Future<List<TontineModel>> getTontines() async {
    final rows = await _db.select(_db.tontines).get();
    return rows.map((row) => _mapRowToModel(row)).toList();
  }

  @override
  Future<void> saveTontines(List<TontineModel> tontines) async {
    // Full replace: this is always fed the complete authoritative list for the
    // current user, so any local row missing from it means the user lost
    // access (left/removed/deleted) and must be purged, not just left behind.
    await _db.transaction(() async {
      await _db.delete(_db.tontines).go();
      await _db.batch((batch) {
        batch.insertAll(
          _db.tontines,
          tontines.map((t) => _mapModelToCompanion(t)),
          mode: InsertMode.insertOrReplace,
        );
      });
    });
  }

  @override
  Future<void> saveTontine(TontineModel tontine) async {
    await _db
        .into(_db.tontines)
        .insertOnConflictUpdate(_mapModelToCompanion(tontine));
  }

  @override
  Future<void> deleteTontine(String id) async {
    await _db.transaction(() async {
      await (_db.delete(_db.tontines)..where((t) => t.id.equals(id))).go();
      await (_db.delete(
        _db.tontineMembers,
      )..where((t) => t.tontineId.equals(id))).go();
      await (_db.delete(
        _db.tontineMessages,
      )..where((t) => t.tontineId.equals(id))).go();
      await (_db.delete(
        _db.tontineContributions,
      )..where((t) => t.tontineId.equals(id))).go();
    });
  }

  @override
  Future<List<TontineMemberModel>> getTontineMembers(String tontineId) async {
    final rows = await (_db.select(
      _db.tontineMembers,
    )..where((t) => t.tontineId.equals(tontineId))).get();
    return rows
        .map(
          (row) => TontineMemberModel(
            id: row.id,
            tontineId: row.tontineId,
            userId: row.userId,
            displayName: row.displayName,
            parts: row.parts,
            trustScore: row.trustScore,
            hasPaidSocialFund: row.hasPaidSocialFund,
          ),
        )
        .toList();
  }

  @override
  Future<void> saveTontineMembers(
    String tontineId,
    List<TontineMemberModel> members,
  ) async {
    // Full replace scoped to this tontine: members removed server-side (left,
    // kicked) must disappear from the local cache too, not just accumulate.
    await _db.transaction(() async {
      await (_db.delete(
        _db.tontineMembers,
      )..where((t) => t.tontineId.equals(tontineId))).go();
      await _db.batch((batch) {
        batch.insertAll(
          _db.tontineMembers,
          members.map(
            (m) => TontineMembersCompanion.insert(
              id: m.id,
              tontineId: m.tontineId,
              userId: m.userId,
              displayName: m.displayName,
              parts: Value(m.parts),
              trustScore: Value(m.trustScore),
              hasPaidSocialFund: Value(m.hasPaidSocialFund),
            ),
          ),
          mode: InsertMode.insertOrReplace,
        );
      });
    });
  }

  @override
  Future<List<TontineMessageModel>> getTontineMessages(String tontineId) async {
    final rows =
        await (_db.select(_db.tontineMessages)
              ..where((t) => t.tontineId.equals(tontineId))
              ..orderBy([
                (t) => OrderingTerm(
                  expression: t.createdAt,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();

    return rows
        .map(
          (row) => TontineMessageModel(
            id: row.id,
            tontineId: row.tontineId,
            senderId: row.senderId,
            content: row.content,
            type: row.type,
            audioUrl: row.audioUrl,
            audioDuration: row.audioDuration,
            createdAt: row.createdAt,
          ),
        )
        .toList();
  }

  @override
  Future<void> saveTontineMessages(
    String tontineId,
    List<TontineMessageModel> messages,
  ) async {
    // Not a full replace: an offline-composed message can still be sitting
    // here as a "temp_" row awaiting sync when this runs, and wiping the
    // table before re-inserting the server's list would delete it before its
    // pending send is confirmed. That row is cleaned up precisely, once sync
    // confirms it, in TontineRepositoryImpl.sendMessage/SyncService instead.
    await _db.batch((batch) {
      batch.insertAll(
        _db.tontineMessages,
        messages.map(
          (m) => TontineMessagesCompanion.insert(
            id: m.id,
            tontineId: m.tontineId,
            senderId: m.senderId,
            content: m.content,
            type: Value(m.type),
            audioUrl: Value(m.audioUrl),
            audioDuration: Value(m.audioDuration),
            createdAt: m.createdAt,
          ),
        ),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  @override
  Future<void> deleteTontineMessage(String id) async {
    await (_db.delete(
      _db.tontineMessages,
    )..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> saveTontineMessage(TontineMessageModel message) async {
    await _db
        .into(_db.tontineMessages)
        .insertOnConflictUpdate(
          TontineMessagesCompanion.insert(
            id: message.id,
            tontineId: message.tontineId,
            senderId: message.senderId,
            content: message.content,
            type: Value(message.type),
            audioUrl: Value(message.audioUrl),
            audioDuration: Value(message.audioDuration),
            createdAt: message.createdAt,
          ),
        );
  }

  @override
  Future<List<TontineContributionModel>> getTontineContributions(
    String tontineId,
  ) async {
    final rows = await (_db.select(
      _db.tontineContributions,
    )..where((t) => t.tontineId.equals(tontineId))).get();
    return rows
        .map(
          (row) => TontineContributionModel(
            id: row.id,
            tontineId: row.tontineId,
            memberId: row.memberId,
            turnIndex: row.turnIndex,
            amountPaid: row.amountPaid,
            proofImage: row.proofImage ?? '',
            validationStatus: row.validationStatus,
            createdAt: row.createdAt,
            aiAnalysis: row.aiAnalysis != null
                ? json.decode(row.aiAnalysis!) as Map<String, dynamic>
                : null,
          ),
        )
        .toList();
  }

  @override
  Future<void> saveTontineContributions(
    String tontineId,
    List<TontineContributionModel> contributions,
  ) async {
    // Full replace scoped to this tontine: this is always fed the complete
    // server list for it, so nothing here is a client-only draft awaiting
    // sync (unlike messages) — safe to purge anything no longer present.
    await _db.transaction(() async {
      await (_db.delete(
        _db.tontineContributions,
      )..where((t) => t.tontineId.equals(tontineId))).go();
      await _db.batch((batch) {
        batch.insertAll(
          _db.tontineContributions,
          contributions.map(
            (c) => TontineContributionsCompanion.insert(
              id: c.id,
              tontineId: c.tontineId,
              memberId: c.memberId,
              turnIndex: c.turnIndex,
              amountPaid: c.amountPaid,
              proofImage: Value(c.proofImage),
              validationStatus: Value(c.validationStatus),
              createdAt: c.createdAt,
              aiAnalysis: Value(
                c.aiAnalysis != null ? json.encode(c.aiAnalysis) : null,
              ),
            ),
          ),
          mode: InsertMode.insertOrReplace,
        );
      });
    });
  }

  TontineModel _mapRowToModel(Tontine row) {
    final extraData = row.extraData != null
        ? json.decode(row.extraData!) as Map<String, dynamic>
        : null;
    return TontineModel(
      id: row.id,
      name: row.name,
      frequency: row.frequency,
      contributionAmount: row.contributionAmount,
      totalParts: row.totalParts,
      currency: row.currency,
      status: row.status,
      creatorId: row.creatorId,
      inviteCode: row.inviteCode ?? '',
      currentTurn: row.currentTurn,
      startDate: row.startDate,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      rotationMode: row.rotationMode ?? 'sequential',
      validationMode: row.validationMode ?? 'admin',
      sanctions: row.sanctions != null
          ? json.decode(row.sanctions!) as Map<String, dynamic>
          : {},
      socialFund: row.socialFund != null
          ? json.decode(row.socialFund!) as Map<String, dynamic>
          : {},
      autoRenew: row.autoRenew,
      rulesAcceptedByAll: row.rulesAcceptedByAll,
      turnSummary: extraData != null && extraData.containsKey('turnSummary')
          ? TurnSummaryModel.fromJson(
              extraData['turnSummary'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  TontinesCompanion _mapModelToCompanion(TontineModel t) {
    return TontinesCompanion.insert(
      id: t.id,
      name: t.name,
      frequency: t.frequency,
      contributionAmount: t.contributionAmount,
      totalParts: t.totalParts,
      currency: Value(t.currency),
      status: Value(t.status),
      creatorId: t.creatorId,
      inviteCode: Value(t.inviteCode),
      currentTurn: Value(t.currentTurn),
      startDate: Value(t.startDate),
      createdAt: Value(t.createdAt),
      updatedAt: Value(t.updatedAt),
      rotationMode: Value(t.rotationMode),
      validationMode: Value(t.validationMode),
      sanctions: Value(json.encode(t.sanctions)),
      socialFund: Value(json.encode(t.socialFund)),
      autoRenew: Value(t.autoRenew),
      rulesAcceptedByAll: Value(t.rulesAcceptedByAll),
      extraData: Value(
        t.turnSummary != null
            ? json.encode({'turnSummary': t.turnSummary!.toJson()})
            : null,
      ),
    );
  }
}
