import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' show MultipartFile;
import 'package:http_parser/http_parser.dart';
import 'package:kauri/core/errors/failures.dart';
import 'package:kauri/core/network/network_info.dart';
import '../datasources/tontine_api_service.dart';
import '../../domain/entities/tontine_entities.dart';
import '../models/tontine_model.dart';
import '../../domain/repositories/tontine_repository.dart';

@LazySingleton(as: TontineRepository)
class TontineRepositoryImpl implements TontineRepository {
  final TontineApiService _apiService;
  final NetworkInfo _networkInfo;

  TontineRepositoryImpl(this._apiService, this._networkInfo);

  @override
  Future<Either<Failure, Tontine>> createTontine(
    Map<String, dynamic> params,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.createTontine(params);
        if (response.isSuccessful && response.body?.data != null) {
          return Right(_mapModelToEntity(response.body!.data!));
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Tontine>>> getTontines() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getTontines();
        if (response.isSuccessful && response.body?.data != null) {
          return Right(response.body!.data!.map(_mapModelToEntity).toList());
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Tontine>> getTontineDetails(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getTontineDetails(id);
        if (response.isSuccessful && response.body?.data != null) {
          return Right(_mapModelToEntity(response.body!.data!));
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Tontine>> updateTontine(
    String id,
    Map<String, dynamic> params,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.updateTontine(id, params);
        if (response.isSuccessful && response.body?.data != null) {
          return Right(_mapModelToEntity(response.body!.data!));
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTontine(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.deleteTontine(id);
        if (response.isSuccessful) return const Right(unit);
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Tontine>> joinTontine(
    String inviteCode, {
    required String displayName,
    required int parts,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.joinTontine({
          'inviteCode': inviteCode,
          'displayName': displayName,
          'parts': parts,
        });
        if (response.isSuccessful && response.body?.data != null) {
          final member = response.body!.data!;
          final tontineResponse = await _apiService.getTontineDetails(
            member.tontineId,
          );
          if (tontineResponse.isSuccessful &&
              tontineResponse.body?.data != null) {
            return Right(_mapModelToEntity(tontineResponse.body!.data!));
          }
          return Left(ServerFailure(_getErrorMessage(tontineResponse.error)));
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Tontine>> startTontine(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.startTontine(id);
        if (response.isSuccessful && response.body?.data != null) {
          return Right(_mapModelToEntity(response.body!.data!));
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<TontineMember>>> getTontineMembers(
    String id,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getTontineMembers(id);
        if (response.isSuccessful && response.body?.data != null) {
          return Right(
            response.body!.data!.map(_mapMemberModelToEntity).toList(),
          );
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, TontineContribution>> contribute(
    String tontineId,
    File proofImage,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final extension = proofImage.path.split('.').last.toLowerCase();
        MediaType? contentType;
        if (extension == 'jpg' || extension == 'jpeg') {
          contentType = MediaType('image', 'jpeg');
        } else if (extension == 'png') {
          contentType = MediaType('image', 'png');
        } else if (extension == 'webp') {
          contentType = MediaType('image', 'webp');
        } else if (extension == 'pdf') {
          contentType = MediaType('application', 'pdf');
        }

        final multipartFile = await MultipartFile.fromPath(
          'receipt',
          proofImage.path,
          contentType: contentType,
        );
        final response = await _apiService.contribute(
          tontineId: tontineId,
          proofImage: multipartFile,
        );
        if (response.isSuccessful && response.body?.data != null) {
          return Right(_mapContributionModelToEntity(response.body!.data!));
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<TontineMessage>>> getTontineMessages(
    String id,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getTontineMessages(id);
        if (response.isSuccessful && response.body?.data != null) {
          return Right(
            response.body!.data!.map(_mapMessageModelToEntity).toList(),
          );
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, TontineMessage>> sendMessage(
    String id,
    String content,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.sendMessage(id, {
          'content': content,
        });
        if (response.isSuccessful && response.body?.data != null) {
          return Right(_mapMessageModelToEntity(response.body!.data!));
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<TontineContribution>>> getContributions(
    String id,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getContributions(id);
        if (response.isSuccessful && response.body?.data != null) {
          return Right(
            response.body!.data!.map(_mapContributionModelToEntity).toList(),
          );
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, TontineContribution>> validateContribution(
    String id,
    String status,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.validateContribution(id, {
          'status': status,
        });
        if (response.isSuccessful && response.body?.data != null) {
          return Right(_mapContributionModelToEntity(response.body!.data!));
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<int>>> exportTontine(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.exportTontine(id);
        if (response.isSuccessful && response.body != null) {
          return Right(response.body!);
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> removeMember(String id, String memberId) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.removeMember(id, memberId);
        if (response.isSuccessful) return const Right(unit);
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  Tontine _mapModelToEntity(TontineModel model) {
    return Tontine(
      id: model.id,
      name: model.name,
      frequency: model.frequency,
      contributionAmount: model.contributionAmount,
      totalParts: model.totalParts,
      currency: model.currency,
      rotationMode: model.rotationMode,
      validationMode: model.validationMode,
      sanctions: model.sanctions,
      escrowDetails: model.escrowDetails,
      socialFund: model.socialFund,
      status: model.status,
      inviteCode: model.inviteCode,
      currentTurn: model.currentTurn,
      creatorId: model.creatorId,
      startDate: model.startDate,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      autoRenew: model.autoRenew,
      rulesAcceptedByAll: model.rulesAcceptedByAll,
      turnSummary: model.turnSummary != null
          ? TurnSummary(
              collectedAmount: model.turnSummary!.collectedAmount,
              expectedAmount: model.turnSummary!.expectedAmount,
              contributorsCount: model.turnSummary!.contributorsCount,
              totalMembers: model.turnSummary!.totalMembers,
            )
          : null,
    );
  }

  TontineMember _mapMemberModelToEntity(TontineMemberModel model) {
    return TontineMember(
      id: model.id,
      tontineId: model.tontineId,
      userId: model.userId,
      displayName: model.displayName,
      parts: model.parts,
      trustScore: model.trustScore,
      hasPaidSocialFund: model.hasPaidSocialFund,
      payoutDetails: model.payoutDetails,
    );
  }

  TontineContribution _mapContributionModelToEntity(
    TontineContributionModel model,
  ) {
    return TontineContribution(
      id: model.id,
      tontineId: model.tontineId,
      memberId: model.memberId,
      turnIndex: model.turnIndex,
      amountPaid: model.amountPaid,
      proofImage: model.proofImage,
      validationStatus: model.validationStatus,
      aiAnalysis: model.aiAnalysis,
      createdAt: model.createdAt,
    );
  }

  TontineMessage _mapMessageModelToEntity(TontineMessageModel model) {
    return TontineMessage(
      id: model.id,
      tontineId: model.tontineId,
      senderId: model.senderId,
      content: model.content,
      createdAt: model.createdAt,
    );
  }

  String _getErrorMessage(dynamic error) {
    if (error is Map) {
      return error['message'] as String? ?? 'Une erreur est survenue';
    }
    return error?.toString() ?? 'Une erreur est survenue';
  }
}
