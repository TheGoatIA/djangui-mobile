import 'package:injectable/injectable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/analytics_api_service.dart';
import '../models/analytics_models.dart';
import '../../domain/repositories/analytics_repository.dart';

@LazySingleton(as: AnalyticsRepository)
class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsApiService _apiService;
  final NetworkInfo _networkInfo;

  AnalyticsRepositoryImpl(this._apiService, this._networkInfo);

  @override
  Future<Either<Failure, void>> trackEvent(UserActivity activity) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.trackEvent(activity.toJson());
        if (response.isSuccessful) {
          return const Right(null);
        }
        return Left(ServerFailure());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
    // For now, only track online. Offline tracking could be added later.
    return const Right(null);
  }

  @override
  Future<Either<Failure, String>> startSession({
    String? deviceId,
    String? platform,
    String? appVersion,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.startSession({
          if (deviceId != null) 'deviceId': deviceId,
          if (platform != null) 'platform': platform,
          if (appVersion != null) 'appVersion': appVersion,
        });
        if (response.isSuccessful && response.body?.data != null) {
          return Right(response.body!.data!.sessionId);
        }
        return Left(ServerFailure());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, void>> endSession(String sessionId) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.endSession({'sessionId': sessionId});
        if (response.isSuccessful) {
          return const Right(null);
        }
        return Left(ServerFailure());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
    return Left(NetworkFailure());
  }
}
