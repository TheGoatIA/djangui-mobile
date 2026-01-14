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

  const ChatMessageModel({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.type = 'text',
    this.metadata,
    this.actions,
  });

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
  ];
}
