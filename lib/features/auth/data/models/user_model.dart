import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: '_id')
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? avatar;
  final bool isPremium;

  final double? monthlyIncome;
  final String? currency;
  final double walletBalance;

  final int xp;
  final int level;
  // Swagger defines badges as objects, but for now we keep List<String> or dynamic
  // until we create a BadgeModel. Let's use dynamic for flexibility or map to a class if we had one.
  // Using List<dynamic> to avoid breakage if backend sends objects.
  final List<dynamic> badges;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.avatar,
    this.isPremium = false,
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
