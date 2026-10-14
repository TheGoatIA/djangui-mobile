import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/network/api_response_extensions.dart';
import '../datasources/reports_api_service.dart';
import '../datasources/reports_local_datasource.dart';
import '../../domain/repositories/reports_repository.dart';
import '../models/reports_model.dart';
import 'package:kauri/core/error/error_mapper.dart';

@LazySingleton(as: ReportsRepository)
class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsApiService _apiService;
  final ForecastApiService _forecastApiService;
  final NetworkInfo _networkInfo;
  final ReportsLocalDataSource _localDataSource;

  ReportsRepositoryImpl(
    this._apiService,
    this._forecastApiService,
    this._networkInfo,
    this._localDataSource,
  );

  @override
  Future<Either<Failure, DashboardReportModel>> getDashboardReport() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getDashboardReport();
        if (response.isSuccessful && response.body?.data != null) {
          final report = response.body!.data!;
          await _localDataSource.saveDashboardReport(report);
          return Right(report);
        }
        return Left(ServerFailure(response.errorMessage));
      } catch (e) {
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    }
    final cached = await _localDataSource.getCachedDashboardReport();
    if (cached != null) return Right(cached);
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, DashboardReportModel?>>
  getCachedDashboardReport() async {
    return Right(await _localDataSource.getCachedDashboardReport());
  }

  @override
  Future<Either<Failure, List<SpendingAnalysisModel>>> getSpendingAnalysis({
    String? period,
  }) async {
    final effectivePeriod = period ?? 'monthly';
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getSpendingAnalysis(period: period);
        if (response.isSuccessful && response.body?.data != null) {
          final data = response.body!.data!;
          await _localDataSource.saveSpendingAnalysis(effectivePeriod, data);
          return Right(data);
        }
        final cachedOnBadResponse = await _localDataSource
            .getCachedSpendingAnalysis(effectivePeriod);
        if (cachedOnBadResponse != null) return Right(cachedOnBadResponse);
        return Left(ServerFailure(response.errorMessage));
      } catch (e) {
        final cached = await _localDataSource.getCachedSpendingAnalysis(
          effectivePeriod,
        );
        if (cached != null) return Right(cached);
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    }
    final cached = await _localDataSource.getCachedSpendingAnalysis(
      effectivePeriod,
    );
    if (cached != null) return Right(cached);
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<SpendingAnalysisModel>?>>
  getCachedSpendingAnalysis(String period) async {
    return Right(await _localDataSource.getCachedSpendingAnalysis(period));
  }

  @override
  Future<Either<Failure, List<SavingsTrendModel>>> getSavingsTrend({
    String? period,
  }) async {
    final effectivePeriod = period ?? 'monthly';
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getSavingsTrend(period: period);
        if (response.isSuccessful && response.body?.data != null) {
          final data = response.body!.data!;
          await _localDataSource.saveSavingsTrend(effectivePeriod, data);
          return Right(data);
        }
        final cachedOnBadResponse = await _localDataSource
            .getCachedSavingsTrend(effectivePeriod);
        if (cachedOnBadResponse != null) return Right(cachedOnBadResponse);
        return Left(ServerFailure(response.errorMessage));
      } catch (e) {
        final cached = await _localDataSource.getCachedSavingsTrend(
          effectivePeriod,
        );
        if (cached != null) return Right(cached);
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    }
    final cached = await _localDataSource.getCachedSavingsTrend(
      effectivePeriod,
    );
    if (cached != null) return Right(cached);
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<SavingsTrendModel>?>> getCachedSavingsTrend(
    String period,
  ) async {
    return Right(await _localDataSource.getCachedSavingsTrend(period));
  }

  @override
  Future<Either<Failure, NarrativeReportModel>> getNarrativeReport() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getNarrativeReport();
        if (response.isSuccessful && response.body?.data != null) {
          final data = response.body!.data!;
          await _localDataSource.saveNarrativeReport(data);
          return Right(data);
        }
        final cachedOnBadResponse = await _localDataSource
            .getCachedNarrativeReport();
        if (cachedOnBadResponse != null) return Right(cachedOnBadResponse);
        return Left(ServerFailure(response.errorMessage));
      } catch (e) {
        final cached = await _localDataSource.getCachedNarrativeReport();
        if (cached != null) return Right(cached);
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    }
    final cached = await _localDataSource.getCachedNarrativeReport();
    if (cached != null) return Right(cached);
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, NarrativeReportModel?>>
  getCachedNarrativeReport() async {
    return Right(await _localDataSource.getCachedNarrativeReport());
  }

  @override
  Future<Either<Failure, ForecastReportModel>> getBalanceForecast() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _forecastApiService.getBalanceForecast();
        if (response.isSuccessful && response.body?.data != null) {
          final data = response.body!.data!;
          await _localDataSource.saveBalanceForecast(data);
          return Right(data);
        }
        final cachedOnBadResponse = await _localDataSource
            .getCachedBalanceForecast();
        if (cachedOnBadResponse != null) return Right(cachedOnBadResponse);
        return Left(ServerFailure(response.errorMessage));
      } catch (e) {
        final cached = await _localDataSource.getCachedBalanceForecast();
        if (cached != null) return Right(cached);
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    }
    final cached = await _localDataSource.getCachedBalanceForecast();
    if (cached != null) return Right(cached);
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, ForecastReportModel?>>
  getCachedBalanceForecast() async {
    return Right(await _localDataSource.getCachedBalanceForecast());
  }

  @override
  Future<Either<Failure, List<HealthScorePointModel>>> getHealthScoreHistory({
    int months = 6,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getHealthScoreHistory(
          months: months,
        );
        if (response.isSuccessful && response.body?.data != null) {
          final data = response.body!.data!;
          await _localDataSource.saveHealthScoreHistory(data);
          return Right(data);
        }
        final cachedOnBadResponse = await _localDataSource
            .getCachedHealthScoreHistory();
        if (cachedOnBadResponse != null) return Right(cachedOnBadResponse);
        return Left(ServerFailure(response.errorMessage));
      } catch (e) {
        final cached = await _localDataSource.getCachedHealthScoreHistory();
        if (cached != null) return Right(cached);
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    }
    final cached = await _localDataSource.getCachedHealthScoreHistory();
    if (cached != null) return Right(cached);
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<HealthScorePointModel>?>>
  getCachedHealthScoreHistory() async {
    return Right(await _localDataSource.getCachedHealthScoreHistory());
  }
}
