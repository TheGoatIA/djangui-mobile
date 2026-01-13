import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/voice_response_model.dart';
import 'dart:io';

abstract class VoiceRepository {
  Future<Either<Failure, VoiceResponseModel>> processVoice(File audioFile);
}
