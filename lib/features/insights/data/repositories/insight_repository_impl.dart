import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/insight_api_service.dart';

import '../../domain/repositories/insight_repository.dart';
import 'package:kauri/core/error/error_mapper.dart';

@LazySingleton(as: InsightRepository)
class InsightRepositoryImpl implements InsightRepository {
  final InsightApiService _apiService;
  final NetworkInfo _networkInfo;

  InsightRepositoryImpl(this._apiService, this._networkInfo);

  @override
  Future<Either<Failure, dynamic>> getDashboardSummary() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getDashboardSummary();
        if (response.isSuccessful && response.body != null) {
          return Right(response.body!);
        }
        return Left(ServerFailure('Failed to fetch dashboard summary'));
      } catch (e) {
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, dynamic>> getSpendingAnalysis({
    int? month,
    int? year,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getSpendingAnalysis(
          month: month,
          year: year,
        );
        if (response.isSuccessful && response.body != null) {
          return Right(response.body!);
        }
        return Left(ServerFailure('Failed to fetch spending analysis'));
      } catch (e) {
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, dynamic>> getNarrative({int? month, int? year}) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getNarrative(
          month: month,
          year: year,
        );
        if (response.isSuccessful && response.body != null) {
          return Right(response.body!);
        }
        return Left(ServerFailure('Failed to fetch narrative'));
      } catch (e) {
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    }
    return Left(NetworkFailure());
  }
}
