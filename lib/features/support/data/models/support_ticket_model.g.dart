// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_ticket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportTicketModel _$SupportTicketModelFromJson(Map<String, dynamic> json) =>
    SupportTicketModel(
      id: json['_id'] as String,
      subject: json['subject'] as String,
      message: json['message'] as String,
      status: json['status'] as String,
      category: json['category'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      replies: (json['responses'] as List<dynamic>?)
          ?.map((e) =>
              SupportTicketReplyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SupportTicketModelToJson(SupportTicketModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'subject': instance.subject,
      'message': instance.message,
      'status': instance.status,
      'category': instance.category,
      'createdAt': instance.createdAt.toIso8601String(),
      'responses': instance.replies,
    };

SupportTicketReplyModel _$SupportTicketReplyModelFromJson(
        Map<String, dynamic> json) =>
    SupportTicketReplyModel(
      message: json['message'] as String,
      sender: json['sender'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$SupportTicketReplyModelToJson(
        SupportTicketReplyModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'sender': instance.sender,
      'createdAt': instance.createdAt.toIso8601String(),
    };
