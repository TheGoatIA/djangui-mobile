import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/reports_api_service.dart';
import '../../domain/repositories/reports_repository.dart';
import '../models/reports_model.dart';

@LazySingleton(as: ReportsRepository)
class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsApiService _apiService;
  final NetworkInfo _networkInfo;

  ReportsRepositoryImpl(this._apiService, this._networkInfo);

  @override
  Future<Either<Failure, DashboardReportModel>> getDashboardReport() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getDashboardReport();
        if (response.isSuccessful && response.body?.data != null) {
          return Right(response.body!.data!);
        }
        return Left(
          ServerFailure(response.error?.toString() ?? 'Erreur serveur'),
        );
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<SpendingAnalysisModel>>>
  getSpendingAnalysis() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getSpendingAnalysis();
        if (response.isSuccessful && response.body?.data != null) {
          return Right(response.body!.data!);
        }
        return Left(
          ServerFailure(response.error?.toString() ?? 'Erreur serveur'),
        );
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<SavingsTrendModel>>> getSavingsTrend() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getSavingsTrend();
        if (response.isSuccessful && response.body?.data != null) {
          return Right(response.body!.data!);
        }
        return Left(
          ServerFailure(response.error?.toString() ?? 'Erreur serveur'),
        );
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, NarrativeReportModel>> getNarrativeReport() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getNarrativeReport();
        if (response.isSuccessful && response.body?.data != null) {
          return Right(response.body!.data!);
        }
        return Left(
          ServerFailure(response.error?.toString() ?? 'Erreur serveur'),
        );
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
    return Left(NetworkFailure());
  }
}
