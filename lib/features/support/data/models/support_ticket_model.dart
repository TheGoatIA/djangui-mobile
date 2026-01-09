import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'support_ticket_model.g.dart';

@JsonSerializable()
class SupportTicketModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String subject;
  final String message;
  final String status; // 'open', 'closed', 'pending'
  final String category; // 'bug', 'payment', 'account', 'other'
  final DateTime createdAt;
  @JsonKey(name: 'responses')
  final List<SupportTicketReplyModel>? replies;

  const SupportTicketModel({
    required this.id,
    required this.subject,
    required this.message,
    required this.status,
    required this.category,
    required this.createdAt,
    this.replies,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) =>
      _$SupportTicketModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupportTicketModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    subject,
    message,
    status,
    category,
    createdAt,
    replies,
  ];
}

@JsonSerializable()
class SupportTicketReplyModel extends Equatable {
  final String message;
  final String sender; // 'user' or 'admin'
  final DateTime createdAt;

  const SupportTicketReplyModel({
    required this.message,
    required this.sender,
    required this.createdAt,
  });

  factory SupportTicketReplyModel.fromJson(Map<String, dynamic> json) =>
      _$SupportTicketReplyModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupportTicketReplyModelToJson(this);

  bool get isAdmin => sender == 'admin';

  @override
  List<Object?> get props => [message, sender, createdAt];
}
