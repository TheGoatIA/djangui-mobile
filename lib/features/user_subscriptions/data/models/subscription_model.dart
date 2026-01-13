import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'subscription_model.g.dart';

@JsonSerializable(includeIfNull: false)
class SubscriptionModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String? userId;
  final String name;
  @JsonKey(includeIfNull: false)
  final String? provider;
  final double amount;
  final String currency;
  final String frequency; // Enum: weekly, monthly, yearly
  @JsonKey(includeIfNull: false)
  final String? category;
  @JsonKey(includeIfNull: false)
  final String? status; // Enum: active, paused, cancelled, expired
  final DateTime nextBillingDate;
  @JsonKey(includeIfNull: false)
  final DateTime? trialEndDate;
  final bool remindMe;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SubscriptionModel({
    this.id,
    this.userId,
    required this.name,
    this.provider,
    required this.amount,
    required this.currency,
    required this.frequency,
    this.category,
    this.status,
    required this.nextBillingDate,
    this.trialEndDate,
    this.remindMe = true,
    this.createdAt,
    this.updatedAt,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    provider,
    amount,
    currency,
    frequency,
    category,
    status,
    nextBillingDate,
    trialEndDate,
    remindMe,
    createdAt,
    updatedAt,
  ];

  SubscriptionModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? provider,
    double? amount,
    String? currency,
    String? frequency,
    String? category,
    String? status,
    DateTime? nextBillingDate,
    DateTime? trialEndDate,
    bool? remindMe,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      provider: provider ?? this.provider,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      frequency: frequency ?? this.frequency,
      category: category ?? this.category,
      status: status ?? this.status,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      trialEndDate: trialEndDate ?? this.trialEndDate,
      remindMe: remindMe ?? this.remindMe,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class SubscriptionSuggestion extends Equatable {
  final String name;
  final double amount;
  final String frequency;
  final double confidence;
  final String? detectedFrom;

  const SubscriptionSuggestion({
    required this.name,
    required this.amount,
    required this.frequency,
    required this.confidence,
    this.detectedFrom,
  });

  factory SubscriptionSuggestion.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionSuggestionFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionSuggestionToJson(this);

  @override
  List<Object?> get props => [
    name,
    amount,
    frequency,
    confidence,
    detectedFrom,
  ];
}
