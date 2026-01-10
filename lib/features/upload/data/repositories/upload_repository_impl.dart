import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/upload_remote_datasource.dart';
import '../models/upload_model.dart';
import '../../domain/repositories/upload_repository.dart';

@LazySingleton(as: UploadRepository)
class UploadRepositoryImpl implements UploadRepository {
  final UploadRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  UploadRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, UploadResponseModel>> uploadAvatar(
    String filePath,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _remoteDataSource.uploadAvatar(filePath);
        return Right(result);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, UploadResponseModel>> uploadReceipt(
    String filePath,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _remoteDataSource.uploadReceipt(filePath);
        return Right(result);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
