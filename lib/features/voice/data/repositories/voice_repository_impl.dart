import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/voice_repository.dart';
import '../datasources/voice_api_service.dart';
import '../models/voice_response_model.dart';

@LazySingleton(as: VoiceRepository)
class VoiceRepositoryImpl implements VoiceRepository {
  final VoiceApiService _voiceApiService;
  final NetworkInfo _networkInfo;

  VoiceRepositoryImpl(this._voiceApiService, this._networkInfo);

  @override
  Future<Either<Failure, VoiceResponseModel>> processVoice(
    File audioFile,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final multipartFile = await http.MultipartFile.fromPath(
          'audio',
          audioFile.path,
          contentType: MediaType('audio', 'm4a'),
        );

        final response = await _voiceApiService.processVoice(multipartFile);

        if (response.isSuccessful && response.body != null) {
          final baseResponse = response.body!;
          if (baseResponse.success && baseResponse.data != null) {
            return Right(baseResponse.data!);
          } else {
            return Left(ServerFailure(baseResponse.message ?? 'Unknown error'));
          }
        } else {
          return Left(ServerFailure('API call failed or empty response'));
        }
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
