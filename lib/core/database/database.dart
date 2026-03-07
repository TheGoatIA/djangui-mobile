import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kauri/core/services/log_service.dart';
import 'package:kauri/di/injection.dart';
import 'package:kauri/core/database/telemetry_executor.dart';

part 'database.g.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get email => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get avatar => text().nullable()();
  IntColumn get xp => integer().withDefault(const Constant(0))();
  IntColumn get level => integer().withDefault(const Constant(1))();
  TextColumn get badges => text().withDefault(const Constant('[]'))();
  BoolColumn get isPremium => boolean().withDefault(const Constant(false))();
  TextColumn get country => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get language => text().withDefault(const Constant('fr'))();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncRequests extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get table => text()(); // 'transactions', 'goals', etc.
  TextColumn get action => text()(); // 'create', 'update', 'delete'
  TextColumn get payload => text()(); // JSON string of the object
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().nullable()();
  RealColumn get amount => real()();
  TextColumn get currency => text().withDefault(const Constant('XAF'))();
  TextColumn get type => text()(); // income, expense, transfer
  TextColumn get category => text()();
  TextColumn get subcategory => text().nullable()();
  TextColumn get description => text()();
  TextColumn get merchant => text().nullable()();
  TextColumn get location => text().nullable()();
  DateTimeColumn get date => dateTime()();
  TextColumn get status => text().withDefault(const Constant('completed'))();
  TextColumn get source => text().nullable()();
  TextColumn get tags => text().withDefault(const Constant('[]'))();
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  TextColumn get recurringFrequency => text().nullable()();
  BoolColumn get isAutoCategorized =>
      boolean().withDefault(const Constant(false))();
  RealColumn get categorizationConfidence => real().nullable()();
  TextColumn get receipt => text().nullable()();
  TextColumn get linkedGoalId => text().nullable()();
  TextColumn get metadata => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Budgets extends Table {
  TextColumn get id => text()();
  TextColumn get period =>
      text()(); // JSON: { month: int, year: int, type: String }
  TextColumn get categories => text()(); // JSON: List<BudgetCategoryModel>
  RealColumn get totalAllocated => real()();
  RealColumn get totalSpent => real()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Goals extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get emoji => text().nullable()();
  TextColumn get type => text().withDefault(const Constant('savings'))();
  RealColumn get targetAmount => real()();
  RealColumn get currentAmount => real()();
  TextColumn get currency => text().withDefault(const Constant('XAF'))();
  DateTimeColumn get deadline => dateTime()();
  TextColumn get category => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get strategy => text().nullable()(); // JSON
  TextColumn get autoSaveRules => text().nullable()(); // JSON
  BoolColumn get isShared => boolean().withDefault(const Constant(false))();
  TextColumn get participants => text().withDefault(const Constant('[]'))();
  TextColumn get image => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Challenges extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get type => text()();
  RealColumn get targetValue => real().nullable()();
  RealColumn get currentValue => real()();
  IntColumn get points => integer()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get difficulty => text().withDefault(const Constant('medium'))();
  IntColumn get durationDays => integer().withDefault(const Constant(30))();
  TextColumn get icon => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get participants => text().withDefault(const Constant('[]'))();
  TextColumn get category => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ChatMessages extends Table {
  TextColumn get id => text()();
  TextColumn get content => text()();
  TextColumn get sender => text()();
  DateTimeColumn get timestamp => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Investments extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  RealColumn get initialAmount => real()();
  RealColumn get currentAmount => real()();
  TextColumn get currency => text().withDefault(const Constant('XAF'))();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get history => text().withDefault(
    const Constant('[]'),
  )(); // JSON: List<InvestmentHistory>
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class UserSubscriptions extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get provider => text().nullable()();
  RealColumn get amount => real()();
  TextColumn get currency => text().withDefault(const Constant('XAF'))();
  TextColumn get frequency => text()();
  TextColumn get category => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  DateTimeColumn get nextBillingDate => dateTime()();
  DateTimeColumn get trialEndDate => dateTime().nullable()();
  BoolColumn get remindMe => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class UserChallenges extends Table {
  TextColumn get id => text()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  RealColumn get progress => real().withDefault(const Constant(0.0))();
  RealColumn get currentValue => real().withDefault(const Constant(0.0))();
  TextColumn get challengeData =>
      text().nullable()(); // JSON representation of ChallengeModel
  TextColumn get weeks => text().nullable()(); // JSON List<ChallengeWeekModel>
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Tontines extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get frequency => text()();
  RealColumn get contributionAmount => real()();
  IntColumn get totalParts => integer()();
  TextColumn get currency => text().withDefault(const Constant('XAF'))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get creatorId => text()();
  TextColumn get inviteCode => text().nullable()();
  IntColumn get currentTurn => integer().withDefault(const Constant(0))();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get rotationMode => text().nullable()();
  TextColumn get validationMode => text().nullable()();
  TextColumn get sanctions => text().nullable()(); // JSON
  TextColumn get socialFund => text().nullable()(); // JSON
  TextColumn get escrowDetails => text().nullable()(); // JSON
  BoolColumn get autoRenew => boolean().nullable()();
  BoolColumn get rulesAcceptedByAll => boolean().nullable()();
  TextColumn get extraData =>
      text().nullable()(); // For turnSummary and other JSON fields

  @override
  Set<Column> get primaryKey => {id};
}

class TontineMembers extends Table {
  TextColumn get id => text()();
  TextColumn get tontineId => text()();
  TextColumn get userId => text()();
  TextColumn get displayName => text()();
  IntColumn get parts => integer().withDefault(const Constant(1))();
  RealColumn get trustScore => real().withDefault(const Constant(0.0))();
  BoolColumn get hasPaidSocialFund =>
      boolean().withDefault(const Constant(false))();
  TextColumn get payoutDetails => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class TontineMessages extends Table {
  TextColumn get id => text()();
  TextColumn get tontineId => text()();
  TextColumn get senderId => text()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class TontineContributions extends Table {
  TextColumn get id => text()();
  TextColumn get tontineId => text()();
  TextColumn get memberId => text()();
  IntColumn get turnIndex => integer()();
  RealColumn get amountPaid => real()();
  TextColumn get proofImage => text().nullable()();
  TextColumn get validationStatus =>
      text().withDefault(const Constant('pending'))();
  TextColumn get aiAnalysis => text().nullable()(); // JSON
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Users,
    Transactions,
    Budgets,
    Goals,
    Challenges,
    ChatMessages,
    Investments,
    SyncRequests,
    UserSubscriptions,
    UserChallenges,
    Tontines,
    TontineMembers,
    TontineMessages,
    TontineContributions,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 20;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 16) {
          await m.createAll(); // Simplified for v16 catchup if needed
        }
        if (from < 17) {
          await m.addColumn(transactions, transactions.userId);
          await m.addColumn(transactions, transactions.location);
          await m.addColumn(transactions, transactions.recurringFrequency);
          await m.addColumn(transactions, transactions.isAutoCategorized);
          await m.addColumn(
            transactions,
            transactions.categorizationConfidence,
          );
          await m.addColumn(transactions, transactions.receipt);
        }
        if (from < 18) {
          await m.createTable(userSubscriptions);
        }
        if (from < 19) {
          await m.createTable(userChallenges);
        }
        if (from < 20) {
          await m.createTable(tontines);
          await m.createTable(tontineMembers);
          await m.createTable(tontineMessages);
          await m.createTable(tontineContributions);
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'db.sqlite'));

      // Retrieve or generate DB encryption key
      final storage = const FlutterSecureStorage();
      String? dbKey = await storage.read(key: 'db_encryption_key');

      if (dbKey == null) {
        // If there's no key but a database already exists, it means it's the old
        // unencrypted version. We must delete it to prevent SQLCipher crash
        // and allow fresh (but encrypted) re-creation. Since all data is synced with the server,
        // it's safe to wipe the local cache.
        if (file.existsSync()) {
          try {
            await file.delete();
            // Also attempt to delete the -shm and -wal files if SQLite created them
            final walFile = File('${file.path}-wal');
            final shmFile = File('${file.path}-shm');
            final journalFile = File('${file.path}-journal');
            if (walFile.existsSync()) await walFile.delete();
            if (shmFile.existsSync()) await shmFile.delete();
            if (journalFile.existsSync()) await journalFile.delete();
            getIt<LogService>().warning(
              'Old unencrypted database was deleted for security migration.',
              component: 'Database',
            );
          } catch (e) {
            getIt<LogService>().error(
              'Failed to delete old unencrypted database',
              error: e,
              component: 'Database',
            );
          }
        }

        // Generate a random key
        final random = Random.secure();
        final bytes = List<int>.generate(32, (i) => random.nextInt(256));
        dbKey = base64UrlEncode(bytes);
        await storage.write(key: 'db_encryption_key', value: dbKey);
      }

      final executor = NativeDatabase(
        file,
        setup: (db) {
          // Verify that the sqlite3 library uses SQLCipher
          // (Requires sqlcipher_flutter_libs instead of sqlite3_flutter_libs)
          db.execute("PRAGMA key = '$dbKey';");
        },
      );
      return TelemetryQueryExecutor(executor);
    });
  }
}
