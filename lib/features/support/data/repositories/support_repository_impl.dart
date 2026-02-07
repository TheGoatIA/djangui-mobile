import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:kauri/core/errors/failures.dart';
import 'package:kauri/core/network/network_info.dart';
import 'package:kauri/features/support/data/datasources/support_api_service.dart';
import 'package:kauri/features/support/data/models/support_ticket_model.dart';
import 'package:kauri/features/support/domain/repositories/support_repository.dart';
import '../../../../core/services/log_service.dart';
import '../../../../di/injection.dart';

@LazySingleton(as: SupportRepository)
class SupportRepositoryImpl implements SupportRepository {
  final SupportApiService _apiService;
  final NetworkInfo _networkInfo;

  SupportRepositoryImpl(this._apiService, this._networkInfo);

  LogService get _logger => getIt<LogService>();

  @override
  Future<Either<Failure, List<SupportTicketModel>>> getTickets() async {
    _logger.info(
      'Récupération de mes tickets de support...',
      component: 'SupportRepository',
    );
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getTickets();
        if (response.isSuccessful && response.body?.data != null) {
          final tickets = response.body!.data!;
          _logger.info(
            '${tickets.length} tickets de support récupérés.',
            component: 'SupportRepository',
          );
          return Right(tickets);
        } else {
          _logger.warning(
            'Échec de la récupération des tickets (Serveur)',
            component: 'SupportRepository',
          );
          return Left(
            ServerFailure(response.error?.toString() ?? 'Server Error'),
          );
        }
      } catch (e) {
        _logger.error(
          'Erreur technique (getTickets)',
          error: e,
          component: 'SupportRepository',
        );
        return Left(ServerFailure(e.toString()));
      }
    } else {
      _logger.warning(
        'Impossible de récupérer les tickets hors-ligne.',
        component: 'SupportRepository',
      );
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> createTicket({
    required String subject,
    required String message,
    String? category,
  }) async {
    _logger.info(
      'Création d\'un nouveau ticket de support: $subject',
      component: 'SupportRepository',
    );
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.createTicket({
          'subject': subject,
          'message': message,
          if (category != null) 'category': category,
        });
        if (response.isSuccessful) {
          _logger.info(
            'Ticket créé avec succès.',
            component: 'SupportRepository',
          );
          return const Right(null);
        } else {
          _logger.warning(
            'Échec de la création du ticket (Serveur)',
            component: 'SupportRepository',
          );
          return Left(
            ServerFailure(response.error?.toString() ?? 'Server Error'),
          );
        }
      } catch (e) {
        _logger.error(
          'Erreur technique (createTicket)',
          error: e,
          component: 'SupportRepository',
        );
        return Left(ServerFailure(e.toString()));
      }
    } else {
      _logger.warning(
        'Impossible de créer un ticket hors-ligne.',
        component: 'SupportRepository',
      );
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> replyToTicket({
    required String ticketId,
    required String message,
  }) async {
    _logger.info(
      'Envoi d\'une réponse au ticket: $ticketId',
      component: 'SupportRepository',
    );
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.replyToTicket(ticketId, {
          'message': message,
        });
        if (response.isSuccessful) {
          _logger.info(
            'Réponse envoyée avec succès.',
            component: 'SupportRepository',
          );
          return const Right(null);
        } else {
          _logger.warning(
            'Échec de l\'envoi de la réponse (Serveur)',
            component: 'SupportRepository',
          );
          return Left(
            ServerFailure(response.error?.toString() ?? 'Server Error'),
          );
        }
      } catch (e) {
        _logger.error(
          'Erreur technique (replyToTicket)',
          error: e,
          component: 'SupportRepository',
        );
        return Left(ServerFailure(e.toString()));
      }
    } else {
      _logger.warning(
        'Impossible de répondre à un ticket hors-ligne.',
        component: 'SupportRepository',
      );
      return Left(NetworkFailure());
    }
  }
}
