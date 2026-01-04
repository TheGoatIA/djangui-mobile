import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

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
  RealColumn get amount => real()();
  TextColumn get currency => text().withDefault(const Constant('XAF'))();
  TextColumn get type => text()(); // income, expense, transfer
  TextColumn get category => text()();
  TextColumn get subcategory => text().nullable()();
  TextColumn get description => text()();
  TextColumn get merchant => text().nullable()();
  DateTimeColumn get date => dateTime()();
  TextColumn get status => text().withDefault(const Constant('completed'))();
  TextColumn get source => text().nullable()();
  TextColumn get tags => text().withDefault(const Constant('[]'))();
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  TextColumn get recurringInterval => text().nullable()();
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
  RealColumn get targetAmount => real()();
  RealColumn get currentAmount => real()();
  TextColumn get currency => text().withDefault(const Constant('XAF'))();
  DateTimeColumn get deadline => dateTime()();
  TextColumn get category => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
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
  RealColumn get targetValue => real()();
  RealColumn get currentValue => real()();
  IntColumn get points => integer()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 11;

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'db.sqlite'));
      return NativeDatabase(file);
    });
  }
}
