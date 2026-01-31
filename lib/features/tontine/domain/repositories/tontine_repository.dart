import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:kauri/core/errors/failures.dart';
import '../entities/tontine_entities.dart';

abstract class TontineRepository {
  Future<Either<Failure, Tontine>> createTontine(Map<String, dynamic> params);
  Future<Either<Failure, List<Tontine>>> getTontines();
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
  Future<Either<Failure, TontineMessage>> sendMessage(
    String id,
    String content,
  );
  Future<Either<Failure, List<TontineContribution>>> getContributions(
    String id,
  );
  Future<Either<Failure, TontineContribution>> validateContribution(
    String id,
    String status,
  );
  Future<Either<Failure, List<int>>> exportTontine(String id);
  Future<Either<Failure, Unit>> removeMember(String id, String memberId);
}
