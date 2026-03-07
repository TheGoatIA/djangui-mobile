import 'dart:io';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/upload_model.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';

abstract class UploadRemoteDataSource {
  Future<UploadResponseModel> uploadAvatar(String filePath);
  Future<UploadResponseModel> uploadReceipt(String filePath);
  Future<UploadResponseModel> uploadDocument(String filePath);
}

@LazySingleton(as: UploadRemoteDataSource)
class UploadRemoteDataSourceImpl implements UploadRemoteDataSource {
  final AuthLocalDataSource _localDataSource;

  UploadRemoteDataSourceImpl(this._localDataSource);

  String get _baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://192.168.1.182:15000/api/v1';

  /// Detects MIME type from file extension.
  MediaType _detectMediaType(String filePath) {
    final ext = filePath.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'pdf':
        return MediaType('application', 'pdf');
      case 'webp':
        return MediaType('image', 'webp');
      default:
        return MediaType('image', 'jpeg');
    }
  }

  Future<UploadResponseModel> _uploadFile({
    required String filePath,
    required String endpoint,
    required String fieldName,
  }) async {
    final token = await _localDataSource.getAccessToken();
    final uri = Uri.parse('$_baseUrl/$endpoint');
    final file = File(filePath);
    final mediaType = _detectMediaType(filePath);

    final request = http.MultipartRequest('POST', uri);
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.files.add(
      await http.MultipartFile.fromPath(
        fieldName,
        file.path,
        contentType: mediaType,
      ),
    );

    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();
    final json = jsonDecode(responseBody) as Map<String, dynamic>;

    if (streamedResponse.statusCode == 200 ||
        streamedResponse.statusCode == 201) {
      final data = json['data'] as Map<String, dynamic>?;
      if (data != null) {
        return UploadResponseModel.fromJson(data);
      }
      return UploadResponseModel.fromJson(json);
    } else {
      throw Exception(
        'Upload failed (${streamedResponse.statusCode}): ${json['message'] ?? responseBody}',
      );
    }
  }

  @override
  Future<UploadResponseModel> uploadAvatar(String filePath) async {
    return _uploadFile(
      filePath: filePath,
      endpoint: 'upload/avatar',
      fieldName: 'avatar',
    );
  }

  @override
  Future<UploadResponseModel> uploadReceipt(String filePath) async {
    return _uploadFile(
      filePath: filePath,
      endpoint: 'upload/receipt',
      fieldName: 'receipt',
    );
  }

  @override
  Future<UploadResponseModel> uploadDocument(String filePath) async {
    return _uploadFile(
      filePath: filePath,
      endpoint: 'upload/document',
      fieldName: 'document',
    );
  }
}
