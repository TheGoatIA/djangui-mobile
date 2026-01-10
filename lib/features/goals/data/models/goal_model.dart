import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'goal_model.g.dart';

@JsonSerializable()
class GoalStrategyModel extends Equatable {
  final String type;
  final Map<String, dynamic> details;

  const GoalStrategyModel({required this.type, this.details = const {}});

  factory GoalStrategyModel.fromJson(Map<String, dynamic> json) =>
      _$GoalStrategyModelFromJson(json);
  Map<String, dynamic> toJson() => _$GoalStrategyModelToJson(this);

  @override
  List<Object?> get props => [type, details];
}

@JsonSerializable()
class AutoSaveRulesModel extends Equatable {
  final bool enableSurplus;
  final bool enableRoundup;
  final double percentageIncome;

  const AutoSaveRulesModel({
    this.enableSurplus = false,
    this.enableRoundup = false,
    this.percentageIncome = 0.0,
  });

  factory AutoSaveRulesModel.fromJson(Map<String, dynamic> json) =>
      _$AutoSaveRulesModelFromJson(json);
  Map<String, dynamic> toJson() => _$AutoSaveRulesModelToJson(this);

  @override
  List<Object?> get props => [enableSurplus, enableRoundup, percentageIncome];
}

@JsonSerializable()
class GoalContributionModel extends Equatable {
  final double amount;
  final DateTime date;
  final String? note;

  const GoalContributionModel({
    required this.amount,
    required this.date,
    this.note,
  });

  factory GoalContributionModel.fromJson(Map<String, dynamic> json) =>
      _$GoalContributionModelFromJson(json);
  Map<String, dynamic> toJson() => _$GoalContributionModelToJson(this);

  @override
  List<Object?> get props => [amount, date, note];
}

@JsonSerializable()
class GoalModel extends Equatable {
  @JsonKey(name: '_id', fromJson: _idFromJson)
  final String id;
  final String name;
  final String? description;
  final String? emoji;
  final String type; // 'emergency', 'savings', 'investment'
  final double targetAmount;
  final double currentAmount;
  final double progress;
  final String currency;
  final DateTime deadline;
  final String? category;
  final String status; // 'active', 'completed', 'abandoned'
  final String priority; // 'low', 'medium', 'high'
  @JsonKey(includeIfNull: true)
  final GoalStrategyModel strategy;
  @JsonKey(includeIfNull: true)
  final AutoSaveRulesModel? autoSaveRules;
  final List<GoalContributionModel> contributions;
  final bool isShared;
  final List<String> participants;
  final String? image;
  final DateTime createdAt;
  final DateTime? updatedAt;

  static String _idFromJson(dynamic id) {
    if (id is Map) return id['\$oid'] ?? id['_id'] ?? id['id'] ?? '';
    return id?.toString() ?? '';
  }

  const GoalModel({
    required this.id,
    required this.name,
    this.description,
    this.emoji,
    this.type = 'savings',
    required this.targetAmount,
    this.currentAmount = 0.0,
    this.progress = 0.0,
    this.currency = 'XAF',
    required this.deadline,
    this.category,
    this.status = 'active',
    this.priority = 'medium',
    this.strategy = const GoalStrategyModel(type: 'custom'),
    this.autoSaveRules,
    this.contributions = const [],
    this.isShared = false,
    this.participants = const [],
    this.image,
    required this.createdAt,
    this.updatedAt,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    // Handle nested data from some list responses
    final data = json['request'] ?? json;
    return _$GoalModelFromJson(data as Map<String, dynamic>);
  }

  Map<String, dynamic> toJson() => _$GoalModelToJson(this);

  GoalModel copyWith({
    String? id,
    String? name,
    String? description,
    String? emoji,
    String? type,
    double? targetAmount,
    double? currentAmount,
    double? progress,
    String? currency,
    DateTime? deadline,
    String? category,
    String? status,
    String? priority,
    GoalStrategyModel? strategy,
    AutoSaveRulesModel? autoSaveRules,
    List<GoalContributionModel>? contributions,
    bool? isShared,
    List<String>? participants,
    String? image,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GoalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      type: type ?? this.type,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      progress: progress ?? this.progress,
      currency: currency ?? this.currency,
      deadline: deadline ?? this.deadline,
      category: category ?? this.category,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      strategy: strategy ?? this.strategy,
      autoSaveRules: autoSaveRules ?? this.autoSaveRules,
      contributions: contributions ?? this.contributions,
      isShared: isShared ?? this.isShared,
      participants: participants ?? this.participants,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    emoji,
    type,
    targetAmount,
    currentAmount,
    progress,
    currency,
    deadline,
    category,
    status,
    priority,
    strategy,
    autoSaveRules,
    contributions,
    isShared,
    participants,
    image,
    createdAt,
    updatedAt,
  ];
}
