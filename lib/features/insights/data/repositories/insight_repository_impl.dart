import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/insight_api_service.dart';
import '../models/insight_model.dart';

abstract class InsightRepository {
  Future<Either<Failure, List<CategoryDistributionModel>>>
  getCategoryDistribution(String period);
  Future<Either<Failure, List<SpendingTrendModel>>> getSpendingTrends(
    String period,
  );
}

@LazySingleton(as: InsightRepository)
class InsightRepositoryImpl implements InsightRepository {
  final InsightApiService _apiService;
  final NetworkInfo _networkInfo;

  InsightRepositoryImpl(this._apiService, this._networkInfo);

  @override
  Future<Either<Failure, List<CategoryDistributionModel>>>
  getCategoryDistribution(String period) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getCategoryDistribution(period);
        if (response.isSuccessful && response.body != null) {
          return Right(response.body!);
        }
        return Left(ServerFailure('Failed to fetch category distribution'));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<SpendingTrendModel>>> getSpendingTrends(
    String period,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getSpendingTrends(period);
        if (response.isSuccessful && response.body != null) {
          return Right(response.body!);
        }
        return Left(ServerFailure('Failed to fetch spending trends'));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
    return Left(NetworkFailure());
  }
}
