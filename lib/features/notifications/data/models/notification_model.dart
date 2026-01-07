import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  @JsonKey(name: '_id')
  final String id;
  final String userId;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? data;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          title == other.title &&
          body == other.body &&
          isRead == other.isRead &&
          createdAt == other.createdAt &&
          data == other.data;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      title.hashCode ^
      body.hashCode ^
      isRead.hashCode ^
      createdAt.hashCode ^
      data.hashCode;

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    bool? isRead,
    DateTime? createdAt,
    Map<String, dynamic>? data,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      data: data ?? this.data,
    );
  }
}
