import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:kauri/core/database/database.dart' as db;
import 'package:kauri/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:kauri/features/transactions/data/models/transaction_model.dart';
import 'package:kauri/features/user_subscriptions/data/datasources/subscription_api_service.dart';
import 'package:kauri/features/user_subscriptions/data/models/subscription_model.dart';
import 'package:kauri/features/challenges/data/datasources/challenge_remote_datasource.dart';
import 'package:kauri/features/goals/data/datasources/goal_remote_datasource.dart';
import 'package:kauri/features/budgets/data/datasources/budget_remote_datasource.dart';
import 'package:kauri/features/budgets/data/models/budget_model.dart';
import 'package:kauri/features/tontine/data/datasources/tontine_api_service.dart';
import 'package:kauri/features/goals/data/models/goal_model.dart';
import 'package:kauri/features/auth/domain/repositories/auth_repository.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Service gérant la synchronisation des données entre le cache local et le serveur.
///
/// Ce service implémente la logique "Offline-First" : il écoute les changements de
/// connectivité et traite la file d'attente (syncRequests) dès que le réseau est disponible.
@lazySingleton
class SyncService {
  final db.AppDatabase _database;
  final TransactionRemoteDataSource _transactionRemoteDataSource;
  final SubscriptionApiService _subscriptionApiService;
  final GoalRemoteDataSource _goalRemoteDataSource;
  final ChallengeRemoteDataSource _challengeRemoteDataSource;
  final BudgetRemoteDataSource _budgetRemoteDataSource;
  final TontineApiService _tontineApiService;
  final AuthRepository _authRepository;
  final Logger _logger;
  final InternetConnectionChecker _connectionChecker;

  SyncService(
    this._database,
    this._transactionRemoteDataSource,
    this._subscriptionApiService,
    this._goalRemoteDataSource,
    this._challengeRemoteDataSource,
    this._budgetRemoteDataSource,
    this._tontineApiService,
    this._authRepository,
    this._logger,
    this._connectionChecker,
  );

  /// Initialise les écouteurs de connectivité réseau.
  void initialize() {
    // Écoute en temps réel des changements d'état (Connecté/Déconnecté)
    _connectionChecker.onStatusChange.listen((status) {
      if (status == InternetConnectionStatus.connected) {
        _logger.i('Connexion rétablie. Déclenchement de la synchronisation...');
        syncPendingRequests();
      }
    });

    // Vérification initiale du statut réseau lors de l'injection du service
    _connectionChecker.hasConnection.then((isConnected) {
      if (isConnected) {
        syncPendingRequests();
      }
    });
  }

  /// Parcourt la base de données locale pour traiter toutes les requêtes en attente.
  Future<void> syncPendingRequests() async {
    // La synchronisation ne s'effectue que si l'utilisateur est authentifié.
    if (!await _authRepository.isAuthenticated()) {
      _logger.d('Synchronisation ignorée : Utilisateur non authentifié.');
      return;
    }

    _logger.i('Début de la synchronisation des requêtes en attente...');
    final requests = await _database.select(_database.syncRequests).get();

    if (requests.isEmpty) {
      _logger.i('Aucune requête en attente.');
      return;
    }

    for (final request in requests) {
      try {
        // Routage de la requête vers la méthode de traitement appropriée selon la table
        if (request.table == 'transactions') {
          await _processTransactionRequest(request);
        } else if (request.table == 'subscriptions') {
          await _processSubscriptionRequest(request);
        } else if (request.table == 'goals') {
          await _processGoalRequest(request);
        } else if (request.table == 'challenges') {
          await _processChallengeRequest(request);
        } else if (request.table == 'budgets') {
          await _processBudgetRequest(request);
        } else if (request.table == 'tontines') {
          await _processTontineRequest(request);
        }

        // Si l'exécution réussit sans exception, on supprime la requête de la file d'attente locale
        await (_database.delete(
          _database.syncRequests,
        )..where((t) => t.id.equals(request.id))).go();
        _logger.i('Requête ${request.id} synchronisée avec succès.');
      } catch (e) {
        _logger.e('Échec de synchronisation pour la requête ${request.id}: $e');
        // En cas d'échec, elle reste en base pour être re-tentée plus tard.
      }
    }
  }

  /// Traite une opération synchronisée spécifique à la table 'transactions'.
  Future<void> _processTransactionRequest(db.SyncRequest request) async {
    final payload = jsonDecode(request.payload);

    if (request.action == 'create') {
      final transaction = TransactionModel.fromJson(payload);
      await _transactionRemoteDataSource.createTransaction(transaction);
    } else if (request.action == 'delete') {
      final id = payload['id'] as String;
      await _transactionRemoteDataSource.deleteTransaction(id);
    }
  }

  /// Traite une opération synchronisée spécifique à la table 'subscriptions'.
  Future<void> _processSubscriptionRequest(db.SyncRequest request) async {
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

  /// Traite une opération synchronisée spécifique à la table 'goals'.
  Future<void> _processGoalRequest(db.SyncRequest request) async {
    final payload = jsonDecode(request.payload);

    if (request.action == 'create') {
      final goal = GoalModel.fromJson(payload);
      await _goalRemoteDataSource.createGoal(goal);
    } else if (request.action == 'delete') {
      final id = payload['id'] as String;
      await _goalRemoteDataSource.deleteGoal(id);
    }
  }

  /// Traite une opération synchronisée spécifique à la table 'challenges'.
  Future<void> _processChallengeRequest(db.SyncRequest request) async {
    final payload = jsonDecode(request.payload);

    if (request.action == 'join') {
      final id = payload['id'] as String;
      await _challengeRemoteDataSource.joinChallenge(id);
    } else if (request.action == 'unjoin') {
      final id = payload['id'] as String;
      await _challengeRemoteDataSource.unjoinChallenge(id);
    } else if (request.action == 'validate_week') {
      await _challengeRemoteDataSource.validateWeek(
        payload['userChallengeId'] as String,
        payload['weekNumber'] as int,
        (payload['amount'] as num).toDouble(),
        payload['proofPath'] as String,
      );
    }
  }

  /// Traite une opération synchronisée spécifique à la table 'budgets'.
  Future<void> _processBudgetRequest(db.SyncRequest request) async {
    final payload = jsonDecode(request.payload);

    if (request.action == 'create') {
      final budget = BudgetModel.fromJson(payload);
      await _budgetRemoteDataSource.createBudget(budget);
    } else if (request.action == 'update') {
      final id = payload['id'] as String;
      final totalAllocated = (payload['totalAllocated'] as num).toDouble();
      await _budgetRemoteDataSource.updateBudget(id, totalAllocated);
    } else if (request.action == 'delete') {
      final id = payload['id'] as String;
      await _budgetRemoteDataSource.deleteBudget(id);
    }
  }

  /// Traite une opération synchronisée spécifique à la table 'tontines'.
  Future<void> _processTontineRequest(db.SyncRequest request) async {
    final payload = jsonDecode(request.payload);

    if (request.action == 'send_message') {
      final tontineId = payload['tontineId'] as String;
      final content = payload['content'] as String;
      await _tontineApiService.sendMessage(tontineId, {'content': content});
    }
  }
}
