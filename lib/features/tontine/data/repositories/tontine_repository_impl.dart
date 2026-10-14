import 'dart:convert';
import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:kauri/core/database/database.dart' as db;
import 'package:http/http.dart' show MultipartFile;
import 'package:http_parser/http_parser.dart';
import 'package:kauri/core/errors/failures.dart';
import 'package:kauri/core/network/network_info.dart';
import '../datasources/tontine_api_service.dart';
import '../datasources/tontine_local_datasource.dart';
import '../../domain/entities/tontine_entities.dart';
import '../models/tontine_model.dart';
import '../../domain/repositories/tontine_repository.dart';
import '../../../../core/services/log_service.dart';
import '../../../../di/injection.dart';
import 'package:kauri/core/error/error_mapper.dart';

@LazySingleton(as: TontineRepository)
class TontineRepositoryImpl implements TontineRepository {
  final TontineApiService _apiService;
  final TontineLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final db.AppDatabase _db;

  TontineRepositoryImpl(
    this._apiService,
    this._localDataSource,
    this._networkInfo,
    this._db,
  );

  LogService get _logger => getIt<LogService>();

  @override
  Future<Either<Failure, Tontine>> createTontine(
    Map<String, dynamic> params,
  ) async {
    _logger.info(
      'Création d\'une tontine: ${params['name']}',
      component: 'TontineRepository',
    );
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.createTontine(params);
        if (response.isSuccessful && response.body?.data != null) {
          final model = response.body!.data!;
          await _localDataSource.saveTontine(model);
          _logger.info(
            'Tontine créée avec succès sur le serveur.',
            component: 'TontineRepository',
            metadata: {'id': model.id},
          );
          return Right(_mapModelToEntity(model));
        }
        _logger.warning(
          'Échec de la création de tontine (Serveur)',
          component: 'TontineRepository',
          metadata: {'error': _getErrorMessage(response.error)},
        );
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        _logger.error(
          'Erreur technique lors de la création de tontine',
          error: e,
          component: 'TontineRepository',
        );
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      _logger.warning(
        'Impossible de créer une tontine hors-ligne.',
        component: 'TontineRepository',
      );
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Tontine>>> getTontines() async {
    _logger.info(
      'Récupération de la liste des tontines...',
      component: 'TontineRepository',
    );
    final localModels = await _localDataSource.getTontines();
    if (localModels.isNotEmpty && !await _networkInfo.isConnected) {
      _logger.info(
        '${localModels.length} tontines récupérées du cache (hors-ligne).',
        component: 'TontineRepository',
      );
      return Right(localModels.map(_mapModelToEntity).toList());
    }

    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getTontines();
        if (response.isSuccessful && response.body?.data != null) {
          final remoteModels = response.body!.data!;
          await _localDataSource.saveTontines(remoteModels);
          _logger.info(
            '${remoteModels.length} tontines récupérées du serveur.',
            component: 'TontineRepository',
          );
          return Right(remoteModels.map(_mapModelToEntity).toList());
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        _logger.error(
          'Erreur technique lors de la récupération des tontines.',
          error: e,
          component: 'TontineRepository',
        );
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      if (localModels.isNotEmpty) {
        return Right(localModels.map(_mapModelToEntity).toList());
      }
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Tontine>>> getCachedTontines() async {
    final localModels = await _localDataSource.getTontines();
    return Right(localModels.map(_mapModelToEntity).toList());
  }

  @override
  Future<Either<Failure, Tontine>> getTontineDetails(String id) async {
    _logger.info(
      'Récupération des détails de la tontine: $id',
      component: 'TontineRepository',
    );
    final localModels = await _localDataSource.getTontines();
    final localModel = localModels.where((t) => t.id == id).firstOrNull;

    if (localModel != null && !await _networkInfo.isConnected) {
      return Right(_mapModelToEntity(localModel));
    }

    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getTontineDetails(id);
        if (response.isSuccessful && response.body?.data != null) {
          final remoteModel = response.body!.data!;
          await _localDataSource.saveTontine(remoteModel);
          _logger.info(
            'Détails de la tontine récupérés du serveur.',
            component: 'TontineRepository',
          );
          return Right(_mapModelToEntity(remoteModel));
        }
        _logger.warning(
          'Échec serveur (getTontineDetails)',
          component: 'TontineRepository',
        );
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        _logger.error(
          'Erreur technique (getTontineDetails)',
          error: e,
          component: 'TontineRepository',
        );
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      if (localModel != null) return Right(_mapModelToEntity(localModel));
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Tontine>> updateTontine(
    String id,
    Map<String, dynamic> params,
  ) async {
    _logger.info(
      'Mise à jour de la tontine: $id',
      component: 'TontineRepository',
    );
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.updateTontine(id, params);
        if (response.isSuccessful && response.body?.data != null) {
          final model = response.body!.data!;
          await _localDataSource.saveTontine(model);
          _logger.info(
            'Tontine mise à jour avec succès.',
            component: 'TontineRepository',
          );
          return Right(_mapModelToEntity(model));
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        _logger.error(
          'Erreur technique (updateTontine)',
          error: e,
          component: 'TontineRepository',
        );
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
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
        if (response.isSuccessful) {
          await _localDataSource.deleteTontine(id);
          return const Right(unit);
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
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
    _logger.info(
      'Tentative de rejoindre une tontine (Code: $inviteCode)',
      component: 'TontineRepository',
    );
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.joinTontine({
          'inviteCode': inviteCode,
          'displayName': displayName,
          'parts': parts,
        });
        if (response.isSuccessful && response.body?.data != null) {
          final member = response.body!.data!;
          _logger.info(
            'Rejoint avec succès. Récupération des détails...',
            component: 'TontineRepository',
          );
          final tontineResponse = await _apiService.getTontineDetails(
            member.tontineId,
          );
          if (tontineResponse.isSuccessful &&
              tontineResponse.body?.data != null) {
            final tontineModel = tontineResponse.body!.data!;
            await _localDataSource.saveTontine(tontineModel);
            _logger.info(
              'Détails de la tontine rejointe récupérés.',
              component: 'TontineRepository',
            );
            return Right(_mapModelToEntity(tontineModel));
          }
          return Left(ServerFailure(_getErrorMessage(tontineResponse.error)));
        }
        _logger.warning(
          'Échec de l\'adhésion à la tontine.',
          component: 'TontineRepository',
        );
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        _logger.error(
          'Erreur technique (joinTontine)',
          error: e,
          component: 'TontineRepository',
        );
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> leaveTontine(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.removeMember(
          id,
          'me',
        ); // Simplified for example
        if (response.isSuccessful) {
          return const Right(null);
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
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
          final model = response.body!.data!;
          await _localDataSource.saveTontine(model);
          return Right(_mapModelToEntity(model));
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<TontineMember>>> getTontineMembers(
    String id,
  ) async {
    final localMembers = await _localDataSource.getTontineMembers(id);
    if (localMembers.isNotEmpty && !await _networkInfo.isConnected) {
      return Right(localMembers.map(_mapMemberModelToEntity).toList());
    }

    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getTontineMembers(id);
        if (response.isSuccessful && response.body?.data != null) {
          final remoteMembers = response.body!.data!;
          await _localDataSource.saveTontineMembers(id, remoteMembers);
          return Right(remoteMembers.map(_mapMemberModelToEntity).toList());
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      if (localMembers.isNotEmpty) {
        return Right(localMembers.map(_mapMemberModelToEntity).toList());
      }
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, TontineMember>> getMemberDetails(
    String tontineId,
    String memberId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getTontineMembers(tontineId);
        if (response.isSuccessful && response.body?.data != null) {
          final memberModel = response.body!.data!
              .where((m) => m.id == memberId)
              .firstOrNull;
          if (memberModel != null) {
            return Right(_mapMemberModelToEntity(memberModel));
          }
          return Left(ServerFailure('Membre non trouvé'));
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      final localMembers = await _localDataSource.getTontineMembers(tontineId);
      final memberModel = localMembers
          .where((m) => m.id == memberId)
          .firstOrNull;
      if (memberModel != null) {
        return Right(_mapMemberModelToEntity(memberModel));
      }
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, TontineContribution>> contribute(
    String tontineId,
    File proofImage,
  ) async {
    _logger.info(
      'Envoi d\'une contribution pour la tontine: $tontineId',
      component: 'TontineRepository',
    );
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
          _logger.info(
            'Contribution envoyée avec succès.',
            component: 'TontineRepository',
          );
          return Right(_mapContributionModelToEntity(response.body!.data!));
        }
        _logger.warning(
          'Échec de l\'envoi de la contribution.',
          component: 'TontineRepository',
        );
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        _logger.error(
          'Erreur technique (contribute)',
          error: e,
          component: 'TontineRepository',
        );
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      _logger.warning(
        'Impossible d\'envoyer une contribution hors-ligne.',
        component: 'TontineRepository',
      );
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<TontineMessage>>> getCachedTontineMessages(
    String id,
  ) async {
    final localMessages = await _localDataSource.getTontineMessages(id);
    return Right(localMessages.map(_mapMessageModelToEntity).toList());
  }

  @override
  Future<Either<Failure, List<TontineMessage>>> getTontineMessages(
    String id,
  ) async {
    final localMessages = await _localDataSource.getTontineMessages(id);
    if (localMessages.isNotEmpty && !await _networkInfo.isConnected) {
      return Right(localMessages.map(_mapMessageModelToEntity).toList());
    }

    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getTontineMessages(id);
        if (response.isSuccessful && response.body?.data != null) {
          final remoteMessages = response.body!.data!;
          await _localDataSource.saveTontineMessages(id, remoteMessages);
          return Right(remoteMessages.map(_mapMessageModelToEntity).toList());
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      if (localMessages.isNotEmpty) {
        return Right(localMessages.map(_mapMessageModelToEntity).toList());
      }
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, TontineMessage>> sendMessage(
    String id,
    String content,
  ) async {
    _logger.info(
      'Envoi d\'un message dans la tontine: $id',
      component: 'TontineRepository',
    );
    // Generate temporary message for UI
    final tempMessage = TontineMessageModel(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      tontineId: id,
      senderId: 'me',
      content: content,
      createdAt: DateTime.now(),
    );
    await _localDataSource.saveTontineMessage(tempMessage);

    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.sendMessage(id, {
          'content': content,
        });
        if (response.isSuccessful && response.body?.data != null) {
          final remoteMessage = response.body!.data!;
          await _localDataSource.saveTontineMessage(remoteMessage);
          _logger.info(
            'Message envoyé avec succès au serveur.',
            component: 'TontineRepository',
          );
          return Right(_mapMessageModelToEntity(remoteMessage));
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        _logger.error(
          'Erreur technique (sendMessage)',
          error: e,
          component: 'TontineRepository',
        );
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      _logger.info(
        'Mode hors-ligne: Message mis en file d\'attente.',
        component: 'TontineRepository',
      );
      await _db
          .into(_db.syncRequests)
          .insert(
            db.SyncRequestsCompanion.insert(
              table: 'tontines',
              action: 'send_message',
              payload: jsonEncode({
                'tontineId': id,
                'content': content,
                'tempId': tempMessage.id,
              }),
            ),
          );
      return Right(_mapMessageModelToEntity(tempMessage));
    }
  }

  @override
  Future<Either<Failure, TontineMessage>> sendVoiceMessage(
    String tontineId,
    File audioFile,
    int durationSeconds,
  ) async {
    // Voice notes are online-only, like proof-image uploads (contribute()) — a
    // recorded file can't be safely queued for later sync (the temp file may not
    // survive until reconnection), so there is no offline fallback here.
    if (!await _networkInfo.isConnected) {
      _logger.warning(
        'Impossible d\'envoyer une note vocale hors-ligne.',
        component: 'TontineRepository',
      );
      return Left(NetworkFailure());
    }

    final tempMessage = TontineMessageModel(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      tontineId: tontineId,
      senderId: 'me',
      content: '🎤 Note vocale',
      type: 'audio',
      audioUrl: null,
      audioDuration: durationSeconds,
      createdAt: DateTime.now(),
    );
    await _localDataSource.saveTontineMessage(tempMessage);

    try {
      final multipartFile = await MultipartFile.fromPath(
        'audio',
        audioFile.path,
        contentType: MediaType('audio', 'mp4'),
      );
      final response = await _apiService.sendVoiceMessage(
        tontineId,
        audioFile: multipartFile,
        duration: durationSeconds.toString(),
      );
      if (response.isSuccessful && response.body?.data != null) {
        final remoteMessage = response.body!.data!;
        await _localDataSource.deleteTontineMessage(tempMessage.id);
        await _localDataSource.saveTontineMessage(remoteMessage);
        _logger.info(
          'Note vocale envoyée avec succès.',
          component: 'TontineRepository',
        );
        return Right(_mapMessageModelToEntity(remoteMessage));
      }
      await _localDataSource.deleteTontineMessage(tempMessage.id);
      return Left(ServerFailure(_getErrorMessage(response.error)));
    } catch (e) {
      await _localDataSource.deleteTontineMessage(tempMessage.id);
      _logger.error(
        'Erreur technique (sendVoiceMessage)',
        error: e,
        component: 'TontineRepository',
      );
      return Left(ServerFailure(ErrorMapper.safeMessage(e)));
    } finally {
      // The recorded file is only ever needed for this one upload attempt
      // (there is no retry path for a failed voice-note send) — clean it up
      // either way so temp recordings don't accumulate on device storage.
      try {
        if (audioFile.existsSync()) audioFile.deleteSync();
      } catch (_) {}
    }
  }

  @override
  Future<Either<Failure, List<TontineContribution>>> getContributions(
    String id,
  ) async {
    final localContributions = await _localDataSource.getTontineContributions(
      id,
    );
    if (localContributions.isNotEmpty && !await _networkInfo.isConnected) {
      return Right(
        localContributions.map(_mapContributionModelToEntity).toList(),
      );
    }

    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getContributions(id);
        if (response.isSuccessful && response.body?.data != null) {
          final remoteContributions = response.body!.data!;
          await _localDataSource.saveTontineContributions(
            id,
            remoteContributions,
          );
          return Right(
            remoteContributions.map(_mapContributionModelToEntity).toList(),
          );
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      if (localContributions.isNotEmpty) {
        return Right(
          localContributions.map(_mapContributionModelToEntity).toList(),
        );
      }
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, TontineContribution>> validateContribution(
    String tontineId,
    String id,
    String status,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.validateContribution(
          tontineId,
          id,
          {'decision': status == 'creator_validated' ? 'approve' : 'reject'},
        );
        if (response.isSuccessful && response.body?.data != null) {
          return Right(_mapContributionModelToEntity(response.body!.data!));
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
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
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
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
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Tontine>> rotateTurn(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.rotateTurn(id);
        if (response.isSuccessful && response.body?.data != null) {
          final model = response.body!.data!;
          await _localDataSource.saveTontine(model);
          return Right(_mapModelToEntity(model));
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, TontineMember>> paySocialFund(String tontineId) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.paySocialFund(tontineId);
        if (response.isSuccessful && response.body?.data != null) {
          return Right(_mapMemberModelToEntity(response.body!.data!));
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, TontineMember>> toggleAutoDebit({
    required String tontineId,
    required String memberId,
    required bool enabled,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.toggleAutoDebit(
          tontineId,
          memberId,
          {'enabled': enabled},
        );
        if (response.isSuccessful && response.body?.data != null) {
          final model = response.body!.data!;
          // Logic to update local member if needed
          return Right(_mapMemberModelToEntity(model));
        }
        return Left(ServerFailure(_getErrorMessage(response.error)));
      } catch (e) {
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
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
      socialFund: model.socialFund,
      status: model.status,
      inviteCode: model.inviteCode,
      currentTurn: model.currentTurn,
      creatorId: model.creatorId,
      startDate: model.startDate,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      autoRenew: model.autoRenew,
      deadline: model.deadline,
      rulesAcceptedByAll: model.rulesAcceptedByAll,
      turnSummary: model.turnSummary != null
          ? TurnSummary(
              collectedAmount: model.turnSummary!.collectedAmount,
              expectedAmount: model.turnSummary!.expectedAmount,
              contributorsCount: model.turnSummary!.contributorsCount,
              totalMembers: model.turnSummary!.totalMembers,
              currentBeneficiaryId: model.turnSummary!.currentBeneficiaryId,
              currentBeneficiaryName:
                  model.turnSummary!.currentBeneficiaryName,
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
      autoDebitEnabled: model.autoDebitEnabled,
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
      type: model.type,
      audioUrl: model.audioUrl,
      audioDuration: model.audioDuration,
      createdAt: model.createdAt,
    );
  }

  String _getErrorMessage(dynamic error) {
    if (error is Map) {
      final msg = error['message'] ?? error['error'] ?? error['detail'];
      if (msg != null) return ErrorMapper.safeMessage(error, backendMessage: msg.toString());
    }
    return ErrorMapper.safeMessage(error, backendMessage: error?.toString());
  }
}
