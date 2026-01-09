import 'package:equatable/equatable.dart';
import '../../data/models/support_ticket_model.dart';

enum SupportStatus { initial, loading, success, failure }

class SupportState extends Equatable {
  final List<SupportTicketModel> tickets;
  final SupportStatus status;
  final String? errorMessage;
  final bool isCreating;
  final bool isReplied;

  const SupportState({
    this.tickets = const [],
    this.status = SupportStatus.initial,
    this.errorMessage,
    this.isCreating = false,
    this.isReplied = false,
  });

  SupportState copyWith({
    List<SupportTicketModel>? tickets,
    SupportStatus? status,
    String? errorMessage,
    bool? isCreating,
    bool? isReplied,
  }) {
    return SupportState(
      tickets: tickets ?? this.tickets,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isCreating: isCreating ?? this.isCreating,
      isReplied: isReplied ?? this.isReplied,
    );
  }

  @override
  List<Object?> get props => [
    tickets,
    status,
    errorMessage,
    isCreating,
    isReplied,
  ];
}
