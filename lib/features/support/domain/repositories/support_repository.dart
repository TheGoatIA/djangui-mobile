import 'package:fpdart/fpdart.dart';
import 'package:kauri/core/errors/failures.dart';
import 'package:kauri/features/support/data/models/support_ticket_model.dart';

abstract class SupportRepository {
  Future<Either<Failure, List<SupportTicketModel>>> getTickets();
  Future<Either<Failure, void>> createTicket({
    required String subject,
    required String message,
    String? category,
  });
  Future<Either<Failure, void>> replyToTicket({
    required String ticketId,
    required String message,
  });
}
