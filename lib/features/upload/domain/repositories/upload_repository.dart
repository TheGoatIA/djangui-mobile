import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/upload_model.dart';

abstract class UploadRepository {
  Future<Either<Failure, UploadResponseModel>> uploadAvatar(String filePath);
  Future<Either<Failure, UploadResponseModel>> uploadReceipt(String filePath);
  Future<Either<Failure, UploadResponseModel>> uploadDocument(String filePath);
}
