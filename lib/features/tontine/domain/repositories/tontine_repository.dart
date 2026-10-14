import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:kauri/core/errors/failures.dart';
import '../entities/tontine_entities.dart';

abstract class TontineRepository {
  Future<Either<Failure, Tontine>> createTontine(Map<String, dynamic> params);
  Future<Either<Failure, List<Tontine>>> getTontines();

  /// Local cache only, never touches the network — used to paint the list
  /// instantly while [getTontines] refreshes it in the background.
  Future<Either<Failure, List<Tontine>>> getCachedTontines();
  Future<Either<Failure, Tontine>> getTontineDetails(String id);
  Future<Either<Failure, Tontine>> updateTontine(
    String id,
    Map<String, dynamic> params,
  );
  Future<Either<Failure, Unit>> deleteTontine(String id);
  Future<Either<Failure, Tontine>> joinTontine(
    String inviteCode, {
    required String displayName,
    required int parts,
  });
  Future<Either<Failure, Tontine>> startTontine(String id);
  Future<Either<Failure, List<TontineMember>>> getTontineMembers(String id);
  Future<Either<Failure, void>> leaveTontine(String id);
  Future<Either<Failure, TontineMember>> getMemberDetails(
    String tontineId,
    String memberId,
  );
  Future<Either<Failure, TontineContribution>> contribute(
    String tontineId,
    File proofImage,
  );
  Future<Either<Failure, List<TontineMessage>>> getTontineMessages(String id);

  /// Local cache only, never touches the network — used to paint the chat
  /// instantly while [getTontineMessages] refreshes it in the background.
  Future<Either<Failure, List<TontineMessage>>> getCachedTontineMessages(
    String id,
  );
  Future<Either<Failure, TontineMessage>> sendMessage(
    String id,
    String content,
  );
  Future<Either<Failure, TontineMessage>> sendVoiceMessage(
    String tontineId,
    File audioFile,
    int durationSeconds,
  );
  Future<Either<Failure, List<TontineContribution>>> getContributions(
    String id,
  );
  Future<Either<Failure, TontineContribution>> validateContribution(
    String tontineId,
    String id,
    String status,
  );
  Future<Either<Failure, Tontine>> rotateTurn(String id);
  Future<Either<Failure, TontineMember>> paySocialFund(String tontineId);
  Future<Either<Failure, TontineMember>> toggleAutoDebit({
    required String tontineId,
    required String memberId,
    required bool enabled,
  });
  Future<Either<Failure, List<int>>> exportTontine(String id);
  Future<Either<Failure, Unit>> removeMember(String id, String memberId);
}
