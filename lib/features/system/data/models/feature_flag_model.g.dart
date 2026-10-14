// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_flag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeatureConfig _$FeatureConfigFromJson(Map<String, dynamic> json) =>
    FeatureConfig(
      isEnabled: json['isEnabled'] as bool? ?? true,
      minAppVersion: json['minAppVersion'] as String? ?? '1.0.0',
    );

Map<String, dynamic> _$FeatureConfigToJson(FeatureConfig instance) =>
    <String, dynamic>{
      'isEnabled': instance.isEnabled,
      'minAppVersion': instance.minAppVersion,
    };

FeatureFlagModel _$FeatureFlagModelFromJson(
  Map<String, dynamic> json,
) => FeatureFlagModel(
  authGoogle: json['auth_google'] == null
      ? const FeatureConfig()
      : FeatureConfig.fromJson(json['auth_google'] as Map<String, dynamic>),
  authApple: json['auth_apple'] == null
      ? const FeatureConfig()
      : FeatureConfig.fromJson(json['auth_apple'] as Map<String, dynamic>),
  authPhone: json['auth_phone'] == null
      ? const FeatureConfig()
      : FeatureConfig.fromJson(json['auth_phone'] as Map<String, dynamic>),
  authBiometric: json['auth_biometric'] == null
      ? const FeatureConfig()
      : FeatureConfig.fromJson(json['auth_biometric'] as Map<String, dynamic>),
  aiCoachChat: json['ai_coach_chat'] == null
      ? const FeatureConfig()
      : FeatureConfig.fromJson(json['ai_coach_chat'] as Map<String, dynamic>),
  aiBudgetGeneration: json['ai_budget_generation'] == null
      ? const FeatureConfig()
      : FeatureConfig.fromJson(
          json['ai_budget_generation'] as Map<String, dynamic>,
        ),
  aiInsights: json['ai_insights'] == null
      ? const FeatureConfig()
      : FeatureConfig.fromJson(json['ai_insights'] as Map<String, dynamic>),
  aiVoiceCommands: json['ai_voice_commands'] == null
      ? const FeatureConfig()
      : FeatureConfig.fromJson(
          json['ai_voice_commands'] as Map<String, dynamic>,
        ),
  featBudgets: json['feat_budgets'] == null
      ? const FeatureConfig()
      : FeatureConfig.fromJson(json['feat_budgets'] as Map<String, dynamic>),
  featGoals: json['feat_goals'] == null
      ? const FeatureConfig()
      : FeatureConfig.fromJson(json['feat_goals'] as Map<String, dynamic>),
  featInvestments: json['feat_investments'] == null
      ? const FeatureConfig()
      : FeatureConfig.fromJson(
          json['feat_investments'] as Map<String, dynamic>,
        ),
  featReports: json['feat_reports'] == null
      ? const FeatureConfig()
      : FeatureConfig.fromJson(json['feat_reports'] as Map<String, dynamic>),
  featScanUpload: json['feat_scan_upload'] == null
      ? const FeatureConfig()
      : FeatureConfig.fromJson(
          json['feat_scan_upload'] as Map<String, dynamic>,
        ),
  featManualTransactions: json['feat_manual_transactions'] == null
      ? const FeatureConfig()
      : FeatureConfig.fromJson(
          json['feat_manual_transactions'] as Map<String, dynamic>,
        ),
  featTontines: json['feat_tontines'] == null
      ? const FeatureConfig()
      : FeatureConfig.fromJson(json['feat_tontines'] as Map<String, dynamic>),
  featGamification: json['feat_gamification'] == null
      ? const FeatureConfig()
      : FeatureConfig.fromJson(
          json['feat_gamification'] as Map<String, dynamic>,
        ),
  featChallenges: json['feat_challenges'] == null
      ? const FeatureConfig()
      : FeatureConfig.fromJson(json['feat_challenges'] as Map<String, dynamic>),
  featNotifications: json['feat_notifications'] == null
      ? const FeatureConfig()
      : FeatureConfig.fromJson(
          json['feat_notifications'] as Map<String, dynamic>,
        ),
  featSubscriptions: json['feat_subscriptions'] == null
      ? const FeatureConfig()
      : FeatureConfig.fromJson(
          json['feat_subscriptions'] as Map<String, dynamic>,
        ),
  featRealMoney: json['feat_real_money'] == null
      ? const FeatureConfig(isEnabled: EnvConfig.enableRealMoney)
      : FeatureConfig.fromJson(json['feat_real_money'] as Map<String, dynamic>),
  realMoneyCountries:
      (json['real_money_countries'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const ['CM'],
);

Map<String, dynamic> _$FeatureFlagModelToJson(FeatureFlagModel instance) =>
    <String, dynamic>{
      'auth_google': instance.authGoogle,
      'auth_apple': instance.authApple,
      'auth_phone': instance.authPhone,
      'auth_biometric': instance.authBiometric,
      'ai_coach_chat': instance.aiCoachChat,
      'ai_budget_generation': instance.aiBudgetGeneration,
      'ai_insights': instance.aiInsights,
      'ai_voice_commands': instance.aiVoiceCommands,
      'feat_budgets': instance.featBudgets,
      'feat_goals': instance.featGoals,
      'feat_investments': instance.featInvestments,
      'feat_reports': instance.featReports,
      'feat_scan_upload': instance.featScanUpload,
      'feat_manual_transactions': instance.featManualTransactions,
      'feat_tontines': instance.featTontines,
      'feat_gamification': instance.featGamification,
      'feat_challenges': instance.featChallenges,
      'feat_notifications': instance.featNotifications,
      'feat_subscriptions': instance.featSubscriptions,
      'feat_real_money': instance.featRealMoney,
      'real_money_countries': instance.realMoneyCountries,
    };
