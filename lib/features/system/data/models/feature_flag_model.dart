import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'feature_flag_model.g.dart';

@JsonSerializable()
class FeatureConfig extends Equatable {
  final bool isEnabled;
  final String minAppVersion;

  const FeatureConfig({this.isEnabled = true, this.minAppVersion = '1.0.0'});

  factory FeatureConfig.fromJson(Map<String, dynamic> json) =>
      _$FeatureConfigFromJson(json);

  Map<String, dynamic> toJson() => _$FeatureConfigToJson(this);

  @override
  List<Object?> get props => [isEnabled, minAppVersion];
}

@JsonSerializable()
class FeatureFlagModel extends Equatable {
  @JsonKey(name: 'auth_google')
  final FeatureConfig authGoogle;
  @JsonKey(name: 'auth_apple')
  final FeatureConfig authApple;
  @JsonKey(name: 'auth_phone')
  final FeatureConfig authPhone;
  @JsonKey(name: 'auth_biometric')
  final FeatureConfig authBiometric;
  @JsonKey(name: 'ai_coach_chat')
  final FeatureConfig aiCoachChat;
  @JsonKey(name: 'ai_budget_generation')
  final FeatureConfig aiBudgetGeneration;
  @JsonKey(name: 'ai_insights')
  final FeatureConfig aiInsights;
  @JsonKey(name: 'ai_voice_commands')
  final FeatureConfig aiVoiceCommands;
  @JsonKey(name: 'feat_budgets')
  final FeatureConfig featBudgets;
  @JsonKey(name: 'feat_goals')
  final FeatureConfig featGoals;
  @JsonKey(name: 'feat_investments')
  final FeatureConfig featInvestments;
  @JsonKey(name: 'feat_reports')
  final FeatureConfig featReports;
  @JsonKey(name: 'feat_scan_upload')
  final FeatureConfig featScanUpload;
  @JsonKey(name: 'feat_manual_transactions')
  final FeatureConfig featManualTransactions;
  @JsonKey(name: 'feat_tontines')
  final FeatureConfig featTontines;
  @JsonKey(name: 'feat_gamification')
  final FeatureConfig featGamification;
  @JsonKey(name: 'feat_challenges')
  final FeatureConfig featChallenges;
  @JsonKey(name: 'feat_notifications')
  final FeatureConfig featNotifications;
  @JsonKey(name: 'feat_subscriptions')
  final FeatureConfig featSubscriptions;

  const FeatureFlagModel({
    this.authGoogle = const FeatureConfig(),
    this.authApple = const FeatureConfig(),
    this.authPhone = const FeatureConfig(),
    this.authBiometric = const FeatureConfig(),
    this.aiCoachChat = const FeatureConfig(),
    this.aiBudgetGeneration = const FeatureConfig(),
    this.aiInsights = const FeatureConfig(),
    this.aiVoiceCommands = const FeatureConfig(),
    this.featBudgets = const FeatureConfig(),
    this.featGoals = const FeatureConfig(),
    this.featInvestments = const FeatureConfig(),
    this.featReports = const FeatureConfig(),
    this.featScanUpload = const FeatureConfig(),
    this.featManualTransactions = const FeatureConfig(),
    this.featTontines = const FeatureConfig(),
    this.featGamification = const FeatureConfig(),
    this.featChallenges = const FeatureConfig(),
    this.featNotifications = const FeatureConfig(),
    this.featSubscriptions = const FeatureConfig(),
  });

  factory FeatureFlagModel.fromJson(Map<String, dynamic> json) =>
      _$FeatureFlagModelFromJson(json);

  Map<String, dynamic> toJson() => _$FeatureFlagModelToJson(this);

  @override
  List<Object?> get props => [
    authGoogle,
    authApple,
    authPhone,
    authBiometric,
    aiCoachChat,
    aiBudgetGeneration,
    aiInsights,
    aiVoiceCommands,
    featBudgets,
    featGoals,
    featInvestments,
    featReports,
    featScanUpload,
    featManualTransactions,
    featTontines,
    featGamification,
    featChallenges,
    featNotifications,
    featSubscriptions,
  ];
}
