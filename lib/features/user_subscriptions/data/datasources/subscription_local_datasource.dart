import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/database.dart';
import '../models/subscription_model.dart';

abstract class SubscriptionLocalDataSource {
  Future<List<SubscriptionModel>> getSubscriptions();
  Future<void> saveSubscriptions(List<SubscriptionModel> subscriptions);
  Future<void> saveSubscription(SubscriptionModel subscription);
  Future<void> deleteSubscription(String id);
  Future<void> deleteAll();
}

@LazySingleton(as: SubscriptionLocalDataSource)
class SubscriptionLocalDataSourceImpl implements SubscriptionLocalDataSource {
  final AppDatabase _db;

  SubscriptionLocalDataSourceImpl(this._db);

  @override
  Future<List<SubscriptionModel>> getSubscriptions() async {
    final rows = await _db.select(_db.userSubscriptions).get();
    return rows
        .map(
          (row) => SubscriptionModel(
            id: row.id,
            name: row.name,
            provider: row.provider,
            amount: row.amount,
            currency: row.currency,
            frequency: row.frequency,
            category: row.category,
            status: row.status,
            nextBillingDate: row.nextBillingDate,
            trialEndDate: row.trialEndDate,
            remindMe: row.remindMe,
            createdAt: row.createdAt,
            updatedAt: row.updatedAt,
          ),
        )
        .toList();
  }

  @override
  Future<void> saveSubscriptions(List<SubscriptionModel> subscriptions) async {
    await _db.batch((batch) {
      batch.insertAll(
        _db.userSubscriptions,
        subscriptions
            .map(
              (s) => UserSubscriptionsCompanion.insert(
                id: s.id!,
                name: s.name,
                provider: Value(s.provider),
                amount: s.amount,
                currency: Value(s.currency),
                frequency: s.frequency,
                category: Value(s.category),
                status: Value(s.status ?? 'active'),
                nextBillingDate: s.nextBillingDate,
                trialEndDate: Value(s.trialEndDate),
                remindMe: Value(s.remindMe),
                createdAt: Value(s.createdAt),
                updatedAt: Value(s.updatedAt),
              ),
            )
            .toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  @override
  Future<void> saveSubscription(SubscriptionModel subscription) async {
    await _db
        .into(_db.userSubscriptions)
        .insertOnConflictUpdate(
          UserSubscriptionsCompanion.insert(
            id: subscription.id!,
            name: subscription.name,
            provider: Value(subscription.provider),
            amount: subscription.amount,
            currency: Value(subscription.currency),
            frequency: subscription.frequency,
            category: Value(subscription.category),
            status: Value(subscription.status ?? 'active'),
            nextBillingDate: subscription.nextBillingDate,
            trialEndDate: Value(subscription.trialEndDate),
            remindMe: Value(subscription.remindMe),
            createdAt: Value(subscription.createdAt),
            updatedAt: Value(subscription.updatedAt),
          ),
        );
  }

  @override
  Future<void> deleteSubscription(String id) async {
    await (_db.delete(
      _db.userSubscriptions,
    )..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> deleteAll() async {
    await _db.delete(_db.userSubscriptions).go();
  }
}
