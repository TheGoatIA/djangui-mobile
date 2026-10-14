import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'chat_message_model.g.dart';

@JsonSerializable()
class ChatMessageModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String text;
  final String sender; // 'user' or 'ai'
  final DateTime timestamp;
  final String? type; // 'text', 'image', 'file'
  final Map<String, dynamic>? metadata;
  final List<dynamic>? actions;
  // Statut purement local (jamais envoyé/reçu du serveur — les messages
  // historiques distants sont toujours considérés 'sent') : 'sending' pendant
  // l'envoi/le streaming, 'failed' si l'envoi a échoué (affiche un bouton
  // réessayer sur CE message précis plutôt qu'une snackbar générique).
  final String status;

  const ChatMessageModel({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.type = 'text',
    this.metadata,
    this.actions,
    this.status = 'sent',
  });

  ChatMessageModel copyWith({String? text, String? status}) {
    return ChatMessageModel(
      id: id,
      text: text ?? this.text,
      sender: sender,
      timestamp: timestamp,
      type: type,
      metadata: metadata,
      actions: actions,
      status: status ?? this.status,
    );
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    text,
    sender,
    timestamp,
    type,
    metadata,
    actions,
    status,
  ];
}
