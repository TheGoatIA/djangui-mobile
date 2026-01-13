import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import '../database/database.dart';
import '../../features/transactions/data/datasources/transaction_remote_datasource.dart';
import '../../features/transactions/data/models/transaction_model.dart';
import '../../features/user_subscriptions/data/datasources/subscription_api_service.dart';
import '../../features/user_subscriptions/data/models/subscription_model.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';

@lazySingleton
class SyncService {
  final AppDatabase _database;
  final TransactionRemoteDataSource _transactionRemoteDataSource;
  final SubscriptionApiService _subscriptionApiService;
  final Logger _logger;
  final InternetConnectionChecker _connectionChecker =
      InternetConnectionChecker.createInstance();

  SyncService(
    this._database,
    this._transactionRemoteDataSource,
    this._subscriptionApiService,
    this._logger,
  );

  void initialize() {
    _connectionChecker.onStatusChange.listen((status) {
      if (status == InternetConnectionStatus.connected) {
        _logger.i('Connection restored. Triggering sync...');
        syncPendingRequests();
      }
    });
    // Check initially
    _connectionChecker.hasConnection.then((isConnected) {
      if (isConnected) {
        syncPendingRequests();
      }
    });
  }

  Future<void> syncPendingRequests() async {
    _logger.i('Starting sync of pending requests...');
    final requests = await _database.select(_database.syncRequests).get();

    if (requests.isEmpty) {
      _logger.i('No pending requests to sync.');
      return;
    }

    for (final request in requests) {
      try {
        if (request.table == 'transactions') {
          await _processTransactionRequest(request);
        } else if (request.table == 'subscriptions') {
          await _processSubscriptionRequest(request);
        }
        // Add other tables here if needed

        // If successful, delete the request
        await (_database.delete(
          _database.syncRequests,
        )..where((t) => t.id.equals(request.id))).go();
        _logger.i('Successfully synced request ${request.id}');
      } catch (e) {
        _logger.e('Failed to sync request ${request.id}: $e');
        // Keep it in DB to retry later
      }
    }
  }

  Future<void> _processTransactionRequest(SyncRequest request) async {
    final payload = jsonDecode(request.payload);

    if (request.action == 'create') {
      final transaction = TransactionModel.fromJson(payload);
      await _transactionRemoteDataSource.createTransaction(transaction);
    } else if (request.action == 'delete') {
      // Payload for delete should be just the ID or object containing ID?
      // Let's assume payload is just the ID string for simplicity in repo,
      // or if it fails, JSON object with field id.
      // Actually creating a standard: payload is always JSON.
      // For delete, assume payload is '{"id": "..."}'
      final id = payload['id'] as String;
      await _transactionRemoteDataSource.deleteTransaction(id);
    }
  }

  Future<void> _processSubscriptionRequest(SyncRequest request) async {
    final payload = jsonDecode(request.payload);

    if (request.action == 'create') {
      final subscription = SubscriptionModel.fromJson(payload);
      await _subscriptionApiService.addSubscription(subscription.toJson());
    } else if (request.action == 'update') {
      final id = payload['_id'] ?? payload['id'];
      final subscription = SubscriptionModel.fromJson(payload);
      await _subscriptionApiService.updateSubscription(
        id as String,
        subscription.toJson(),
      );
    } else if (request.action == 'delete') {
      final id = payload['id'] as String;
      await _subscriptionApiService.deleteSubscription(id);
    }
  }
}
