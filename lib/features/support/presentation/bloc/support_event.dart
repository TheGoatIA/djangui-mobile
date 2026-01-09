import 'package:equatable/equatable.dart';

abstract class SupportEvent extends Equatable {
  const SupportEvent();

  @override
  List<Object?> get props => [];
}

class GetTicketsRequested extends SupportEvent {}

class CreateTicketRequested extends SupportEvent {
  final String subject;
  final String message;
  final String category;

  const CreateTicketRequested({
    required this.subject,
    required this.message,
    required this.category,
  });

  @override
  List<Object?> get props => [subject, message, category];
}

class ReplyToTicketRequested extends SupportEvent {
  final String ticketId;
  final String message;

  const ReplyToTicketRequested({required this.ticketId, required this.message});

  @override
  List<Object?> get props => [ticketId, message];
}
