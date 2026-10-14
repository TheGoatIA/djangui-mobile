import 'package:injectable/injectable.dart';
import 'package:chopper/chopper.dart';
import 'package:http/http.dart' show MultipartFile;
import 'package:http_parser/http_parser.dart';
import 'upload_api_service.dart';
import '../models/upload_model.dart';
import '../../../../core/network/models/base_response.dart';
import 'package:kauri/core/network/api_response_extensions.dart';

abstract class UploadRemoteDataSource {
  Future<UploadResponseModel> uploadAvatar(String filePath);
  Future<UploadResponseModel> generateAvatar(String style, String? refinement);
  Future<UploadResponseModel> applyGeneratedAvatar(String avatarUrl);
  Future<UploadResponseModel> uploadReceipt(String filePath);
  Future<UploadResponseModel> uploadDocument(String filePath);
}

// Routed through UploadApiService (Chopper) rather than a hand-rolled
// http.MultipartRequest — this is what actually gives KYC document/selfie
// uploads (the most sensitive data flow in the app) the same auth-refresh
// pipeline (KauriAuthenticator) as every other API call: a token that expires
// mid-submission now transparently refreshes and retries instead of failing.
@LazySingleton(as: UploadRemoteDataSource)
class UploadRemoteDataSourceImpl implements UploadRemoteDataSource {
  final UploadApiService _apiService;

  UploadRemoteDataSourceImpl(this._apiService);

  MediaType _getMediaType(String filePath) {
    final ext = filePath.split('.').last.toLowerCase();
    if (ext == 'pdf') {
      return MediaType('application', 'pdf');
    } else if (ext == 'png') {
      return MediaType('image', 'png');
    } else if (ext == 'webp') {
      return MediaType('image', 'webp');
    }
    return MediaType('image', 'jpeg');
  }

  UploadResponseModel _unwrap(
    Response<BaseResponse<UploadResponseModel>> response,
  ) {
    if (!response.isSuccessful) {
      throw Exception(response.errorMessage);
    }
    final data = response.body?.data;
    if (data == null) {
      throw Exception('Upload failed: réponse vide du serveur');
    }
    return data;
  }

  @override
  Future<UploadResponseModel> uploadAvatar(String filePath) async {
    final file = await MultipartFile.fromPath(
      'avatar',
      filePath,
      contentType: _getMediaType(filePath),
    );
    return _unwrap(await _apiService.uploadAvatar(file));
  }

  @override
  Future<UploadResponseModel> generateAvatar(
    String style,
    String? refinement,
  ) async {
    return _unwrap(
      await _apiService.generateAvatar({
        'style': style,
        if (refinement != null && refinement.trim().isNotEmpty)
          'refinement': refinement.trim(),
      }),
    );
  }

  @override
  Future<UploadResponseModel> applyGeneratedAvatar(String avatarUrl) async {
    return _unwrap(
      await _apiService.applyGeneratedAvatar({'avatarUrl': avatarUrl}),
    );
  }

  @override
  Future<UploadResponseModel> uploadReceipt(String filePath) async {
    final file = await MultipartFile.fromPath(
      'receipt',
      filePath,
      contentType: _getMediaType(filePath),
    );
    return _unwrap(await _apiService.uploadReceipt(file));
  }

  @override
  Future<UploadResponseModel> uploadDocument(String filePath) async {
    final file = await MultipartFile.fromPath(
      'document',
      filePath,
      contentType: _getMediaType(filePath),
    );
    return _unwrap(await _apiService.uploadDocument(file));
  }
}
