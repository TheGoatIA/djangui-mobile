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
  final bool isActive;
  final bool isPremium;
  final String role; // user, admin
  final String status; // active, inactive, suspended
  final String kycLevel; // verified, pending, rejected
  final int aiAttackCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLogin;

  final double? monthlyIncome;
  final String? currency;
  final String? language;
  final double walletBalance;

  final int xp;
  final int level;
  final List<BadgeModel> badges;

  final UserPreferences? preferences;
  final UserSubscription? subscription;
  final KycDataModel? kycData;

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
    this.isActive = true,
    this.isPremium = false,
    this.role = 'user',
    this.status = 'active',
    this.kycLevel = 'pending',
    this.aiAttackCount = 0,
    this.createdAt,
    this.updatedAt,
    this.lastLogin,
    this.monthlyIncome,
    this.currency,
    this.language,
    this.walletBalance = 0.0,
    this.xp = 0,
    this.level = 1,
    this.badges = const [],
    this.preferences,
    this.subscription,
    this.kycData,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  String get fullName => '$firstName $lastName';
}

@JsonSerializable()
class UserPreferences {
  final String? coachTone;
  final String? notificationFrequency;
  final int? budgetAlertThreshold;

  UserPreferences({
    this.coachTone,
    this.notificationFrequency,
    this.budgetAlertThreshold,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);
}

@JsonSerializable()
class UserSubscription {
  final String? plan;
  final String? status;
  final bool? autoRenew;
  final DateTime? startDate;
  final DateTime? endDate;

  UserSubscription({
    this.plan,
    this.status,
    this.autoRenew,
    this.startDate,
    this.endDate,
  });

  factory UserSubscription.fromJson(Map<String, dynamic> json) =>
      _$UserSubscriptionFromJson(json);
  Map<String, dynamic> toJson() => _$UserSubscriptionToJson(this);
}

@JsonSerializable()
class KycDataModel {
  final String? documentType;
  final String? documentNumber;
  final String? fullName;
  final DateTime? documentExpiryDate;
  final String? documentImageUrl;
  final String? documentBackImageUrl;
  final String? selfieImageUrl;
  final String? rejectionReason;
  final DateTime? verifiedAt;

  KycDataModel({
    this.documentType,
    this.documentNumber,
    this.fullName,
    this.documentExpiryDate,
    this.documentImageUrl,
    this.documentBackImageUrl,
    this.selfieImageUrl,
    this.rejectionReason,
    this.verifiedAt,
  });

  factory KycDataModel.fromJson(Map<String, dynamic> json) =>
      _$KycDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$KycDataModelToJson(this);
}

