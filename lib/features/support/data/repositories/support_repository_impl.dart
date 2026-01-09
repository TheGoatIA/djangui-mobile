import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:djangui/core/errors/failures.dart';
import 'package:djangui/core/network/network_info.dart';
import 'package:djangui/features/support/data/datasources/support_api_service.dart';
import 'package:djangui/features/support/data/models/support_ticket_model.dart';
import 'package:djangui/features/support/domain/repositories/support_repository.dart';

@LazySingleton(as: SupportRepository)
class SupportRepositoryImpl implements SupportRepository {
  final SupportApiService _apiService;
  final NetworkInfo _networkInfo;

  SupportRepositoryImpl(this._apiService, this._networkInfo);

  @override
  Future<Either<Failure, List<SupportTicketModel>>> getTickets() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.getTickets();
        if (response.isSuccessful && response.body?.data != null) {
          return Right(response.body!.data!);
        } else {
          return Left(
            ServerFailure(response.error?.toString() ?? 'Server Error'),
          );
        }
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> createTicket({
    required String subject,
    required String message,
    String? category,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.createTicket({
          'subject': subject,
          'message': message,
          if (category != null) 'category': category,
        });
        if (response.isSuccessful) {
          return const Right(null);
        } else {
          return Left(
            ServerFailure(response.error?.toString() ?? 'Server Error'),
          );
        }
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> replyToTicket({
    required String ticketId,
    required String message,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiService.replyToTicket(ticketId, {
          'message': message,
        });
        if (response.isSuccessful) {
          return const Right(null);
        } else {
          return Left(
            ServerFailure(response.error?.toString() ?? 'Server Error'),
          );
        }
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
