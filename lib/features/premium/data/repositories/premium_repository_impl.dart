import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:kauri/core/errors/failures.dart';
import '../../domain/repositories/premium_repository.dart';
import '../datasources/premium_api_service.dart';
import 'package:kauri/core/error/error_mapper.dart';

@LazySingleton(as: PremiumRepository)
class PremiumRepositoryImpl implements PremiumRepository {
  final PremiumApiService _apiService;

  PremiumRepositoryImpl(this._apiService);

  @override
  Future<Either<Failure, Map<String, dynamic>>> askCoach(String message) async {
    try {
      final response = await _apiService.askCoach({'message': message});
      final body = response.body;
      if (response.isSuccessful && body != null && body.data != null) {
        return Right(body.data!);
      }
      return Left(ServerFailure('Échec de la communication avec le coach'));
    } catch (e) {
      return Left(ServerFailure(ErrorMapper.safeMessage(e)));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getAutoBudget() async {
    try {
      final response = await _apiService.getAutoBudget();
      final body = response.body;
      if (response.isSuccessful && body != null && body.data != null) {
        return Right(body.data!);
      }
      return Left(
        ServerFailure('Échec de la récupération du budget automatique'),
      );
    } catch (e) {
      return Left(ServerFailure(ErrorMapper.safeMessage(e)));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getPremiumReport() async {
    try {
      final response = await _apiService.getPremiumReport();
      final body = response.body;
      if (response.isSuccessful && body != null && body.data != null) {
        return Right(body.data!);
      }
      return Left(ServerFailure('Échec de la récupération du rapport premium'));
    } catch (e) {
      return Left(ServerFailure(ErrorMapper.safeMessage(e)));
    }
  }
}
