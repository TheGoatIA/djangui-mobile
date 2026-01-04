import 'package:json_annotation/json_annotation.dart';
import 'badge_model.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: '_id')
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? avatar;
  final String? country;
  final String? phone;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final String role; // user, admin
  final String status; // active, inactive, suspended
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final double? monthlyIncome;
  final String? currency;
  final double walletBalance;

  final int xp;
  final int level;
  final List<BadgeModel> badges;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.avatar,
    this.country,
    this.phone,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.role = 'user',
    this.status = 'active',
    this.createdAt,
    this.updatedAt,
    this.monthlyIncome,
    this.currency,
    this.walletBalance = 0.0,
    this.xp = 0,
    this.level = 1,
    this.badges = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  String get fullName => '$firstName $lastName';
}
