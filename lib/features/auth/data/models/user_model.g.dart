// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['_id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      avatar: json['avatar'] as String?,
      isPremium: json['isPremium'] as bool? ?? false,
      monthlyIncome: (json['monthlyIncome'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 0.0,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      badges: json['badges'] as List<dynamic>? ?? const [],
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      '_id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'avatar': instance.avatar,
      'isPremium': instance.isPremium,
      'monthlyIncome': instance.monthlyIncome,
      'currency': instance.currency,
      'walletBalance': instance.walletBalance,
      'xp': instance.xp,
      'level': instance.level,
      'badges': instance.badges,
    };
