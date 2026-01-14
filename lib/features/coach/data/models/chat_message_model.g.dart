// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) =>
    ChatMessageModel(
      id: json['_id'] as String,
      text: json['text'] as String,
      sender: json['sender'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: json['type'] as String? ?? 'text',
      metadata: json['metadata'] as Map<String, dynamic>?,
      actions: json['actions'] as List<dynamic>?,
    );

Map<String, dynamic> _$ChatMessageModelToJson(ChatMessageModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'text': instance.text,
      'sender': instance.sender,
      'timestamp': instance.timestamp.toIso8601String(),
      'type': instance.type,
      'metadata': instance.metadata,
      'actions': instance.actions,
    };
