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

  @override
  Future<Either<Failure, List<SubscriptionModel>>> getSubscriptions() async {
    // Return local data immediately if available
    final localSubs = await _localDataSource.getSubscriptions();
    if (localSubs.isNotEmpty && !await _networkInfo.isConnected) {
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
          return Right(subscriptions);
        }
        // If API fails, return local data as fallback
        if (localSubs.isNotEmpty) return Right(localSubs);
        return Left(ServerFailure(response.body?.message ?? 'Server error'));
      } catch (e) {
        if (localSubs.isNotEmpty) return Right(localSubs);
        return Left(ServerFailure(e.toString()));
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
      return Left(ServerFailure(response.body?.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addSubscription(
    SubscriptionModel subscription,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.addSubscription(
          subscription.toJson(),
        );
        if (response.isSuccessful && response.body?.data != null) {
          final newSub = response.body!.data!;
          await _localDataSource.saveSubscription(newSub);
          return const Right(null);
        }
        return Left(ServerFailure(response.body?.message ?? 'Server error'));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final tempId =
            subscription.id ?? 'temp_${DateTime.now().millisecondsSinceEpoch}';
        final subToSave = subscription.copyWith(id: tempId);
        await _localDataSource.saveSubscription(subToSave);

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
        return Left(CacheFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, void>> updateSubscription(
    String id,
    SubscriptionModel subscription,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.updateSubscription(
          id,
          subscription.toJson(),
        );
        if (response.isSuccessful) {
          await _localDataSource.saveSubscription(subscription);
          return const Right(null);
        }
        return Left(ServerFailure());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        await _localDataSource.saveSubscription(subscription);
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
        return Left(CacheFailure(e.toString()));
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
        return Left(ServerFailure(e.toString()));
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
        return Left(CacheFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<SubscriptionSuggestion>>>
  detectSubscriptions() async {
    try {
      final response = await _apiService.detectSubscriptions();
      if (response.isSuccessful && response.body != null) {
        final suggestions = response.body!.data ?? [];
        return Right(suggestions);
      }
      return Left(ServerFailure(response.body?.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
