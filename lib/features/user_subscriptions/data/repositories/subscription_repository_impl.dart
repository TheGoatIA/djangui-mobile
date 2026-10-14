import 'dart:async';
import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/database.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/subscription_api_service.dart';
import '../datasources/subscription_local_datasource.dart';
import '../models/subscription_model.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../../../core/services/log_service.dart';
import '../../../../di/injection.dart';
import 'package:kauri/core/error/error_mapper.dart';
import 'package:kauri/core/network/api_response_extensions.dart';

@LazySingleton(as: SubscriptionRepository)
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionApiService _apiService;
  final SubscriptionLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final AppDatabase _db;

  SubscriptionRepositoryImpl(
    this._apiService,
    this._localDataSource,
    this._networkInfo,
    this._db,
  );

  LogService get _logger => getIt<LogService>();

  @override
  Future<Either<Failure, List<SubscriptionModel>>> getSubscriptions() async {
    _logger.info(
      'Récupération des abonnements...',
      component: 'SubscriptionRepository',
    );
    // Return local data immediately if available
    final localSubs = await _localDataSource.getSubscriptions();
    if (localSubs.isNotEmpty && !await _networkInfo.isConnected) {
      _logger.info(
        '${localSubs.length} abonnements récupérés du cache local (hors-ligne).',
        component: 'SubscriptionRepository',
      );
      return Right(localSubs);
    }

    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getSubscriptions().timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException('Subscription API timeout'),
        );

        if (response.isSuccessful && response.body != null) {
          final subscriptions = response.body!.data ?? [];
          await _localDataSource.saveSubscriptions(subscriptions);
          _logger.info(
            '${subscriptions.length} abonnements récupérés du serveur.',
            component: 'SubscriptionRepository',
          );
          return Right(subscriptions);
        }
        // If API fails, return local data as fallback
        if (localSubs.isNotEmpty) {
          _logger.warning(
            'Échec serveur (getSubscriptions), fallback sur le cache.',
            component: 'SubscriptionRepository',
          );
          return Right(localSubs);
        }
        return Left(ServerFailure(response.errorMessage));
      } catch (e) {
        if (localSubs.isNotEmpty) {
          _logger.error(
            'Erreur technique (getSubscriptions), fallback sur le cache.',
            error: e,
            component: 'SubscriptionRepository',
          );
          return Right(localSubs);
        }
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      if (localSubs.isNotEmpty) return Right(localSubs);
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, SubscriptionModel>> getSubscriptionDetails(
    String id,
  ) async {
    try {
      final response = await _apiService.getSubscriptionDetails(id);
      if (response.isSuccessful && response.body?.data != null) {
        return Right(response.body!.data!);
      }
      return Left(ServerFailure(response.errorMessage));
    } catch (e) {
      return Left(ServerFailure(ErrorMapper.safeMessage(e)));
    }
  }

  @override
  Future<Either<Failure, void>> addSubscription(
    SubscriptionModel subscription,
  ) async {
    _logger.info(
      'Ajout d\'un abonnement: ${subscription.name}',
      component: 'SubscriptionRepository',
    );
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.addSubscription(
          subscription.toJson(),
        );
        if (response.isSuccessful && response.body?.data != null) {
          final newSub = response.body!.data!;
          await _localDataSource.saveSubscription(newSub);
          _logger.info(
            'Abonnement ajouté avec succès sur le serveur.',
            component: 'SubscriptionRepository',
            metadata: {'id': newSub.id},
          );
          return const Right(null);
        }
        _logger.warning(
          'Échec de l\'ajout de l\'abonnement sur le serveur.',
          component: 'SubscriptionRepository',
        );
        return Left(ServerFailure(response.errorMessage));
      } catch (e) {
        _logger.error(
          'Erreur technique lors de l\'ajout de l\'abonnement',
          error: e,
          component: 'SubscriptionRepository',
        );
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      try {
        final tempId =
            subscription.id ?? 'temp_${DateTime.now().millisecondsSinceEpoch}';
        final subToSave = subscription.copyWith(id: tempId);
        await _localDataSource.saveSubscription(subToSave);

        _logger.info(
          'Mode hors-ligne: Abonnement ajouté à la file d\'attente.',
          component: 'SubscriptionRepository',
        );
        await _db
            .into(_db.syncRequests)
            .insert(
              SyncRequestsCompanion.insert(
                table: 'subscriptions',
                action: 'create',
                payload: jsonEncode(subToSave.toJson()),
              ),
            );
        return const Right(null);
      } catch (e) {
        return Left(CacheFailure(ErrorMapper.safeMessage(e)));
      }
    }
  }

  @override
  Future<Either<Failure, void>> updateSubscription(
    String id,
    SubscriptionModel subscription,
  ) async {
    _logger.info(
      'Mise à jour de l\'abonnement: $id',
      component: 'SubscriptionRepository',
    );
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.updateSubscription(
          id,
          subscription.toJson(),
        );
        if (response.isSuccessful) {
          await _localDataSource.saveSubscription(subscription);
          _logger.info(
            'Abonnement mis à jour avec succès.',
            component: 'SubscriptionRepository',
          );
          return const Right(null);
        }
        return Left(ServerFailure());
      } catch (e) {
        _logger.error(
          'Erreur technique lors de la mise à jour de l\'abonnement',
          error: e,
          component: 'SubscriptionRepository',
        );
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      try {
        await _localDataSource.saveSubscription(subscription);
        _logger.info(
          'Mode hors-ligne: Mise à jour ajoutée à la file d\'attente.',
          component: 'SubscriptionRepository',
        );
        await _db
            .into(_db.syncRequests)
            .insert(
              SyncRequestsCompanion.insert(
                table: 'subscriptions',
                action: 'update',
                payload: jsonEncode(subscription.toJson()),
              ),
            );
        return const Right(null);
      } catch (e) {
        return Left(CacheFailure(ErrorMapper.safeMessage(e)));
      }
    }
  }

  @override
  Future<Either<Failure, void>> deleteSubscription(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.deleteSubscription(id);
        if (response.isSuccessful) {
          await _localDataSource.deleteSubscription(id);
          return const Right(null);
        }
        return Left(ServerFailure());
      } catch (e) {
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      try {
        await _localDataSource.deleteSubscription(id);
        await _db
            .into(_db.syncRequests)
            .insert(
              SyncRequestsCompanion.insert(
                table: 'subscriptions',
                action: 'delete',
                payload: jsonEncode({'id': id}),
              ),
            );
        return const Right(null);
      } catch (e) {
        return Left(CacheFailure(ErrorMapper.safeMessage(e)));
      }
    }
  }

  @override
  Future<Either<Failure, List<SubscriptionSuggestion>>>
  detectSubscriptions() async {
    _logger.info(
      'Détection automatique d\'abonnements...',
      component: 'SubscriptionRepository',
    );
    try {
      final response = await _apiService.detectSubscriptions();
      if (response.isSuccessful && response.body != null) {
        final suggestions = response.body!.data ?? [];
        _logger.info(
          '${suggestions.length} suggestions d\'abonnements détectées.',
          component: 'SubscriptionRepository',
        );
        return Right(suggestions);
      }
      return Left(ServerFailure(response.errorMessage));
    } catch (e) {
      _logger.error(
        'Erreur lors de la détection d\'abonnements',
        error: e,
        component: 'SubscriptionRepository',
      );
      return Left(ServerFailure(ErrorMapper.safeMessage(e)));
    }
  }
}
