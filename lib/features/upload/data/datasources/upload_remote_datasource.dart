import 'package:http/http.dart' show MultipartFile;
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';
import '../models/upload_model.dart';
import 'upload_api_service.dart';

abstract class UploadRemoteDataSource {
  Future<UploadResponseModel> uploadAvatar(String filePath);
  Future<UploadResponseModel> uploadReceipt(String filePath);
}

@LazySingleton(as: UploadRemoteDataSource)
class UploadRemoteDataSourceImpl implements UploadRemoteDataSource {
  final UploadApiService _apiService;

  UploadRemoteDataSourceImpl(this._apiService);

  @override
  Future<UploadResponseModel> uploadAvatar(String filePath) async {
    final file = await MultipartFile.fromPath(
      'avatar',
      filePath,
      contentType: MediaType('image', 'jpeg'), // Force JPEG for now or detect
    );
    final response = await _apiService.uploadAvatar(file);
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception('Avatar upload failed: ${response.error}');
    }
  }

  @override
  Future<UploadResponseModel> uploadReceipt(String filePath) async {
    final response = await _apiService.uploadReceipt(filePath);
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception('Receipt upload failed');
    }
  }
}
