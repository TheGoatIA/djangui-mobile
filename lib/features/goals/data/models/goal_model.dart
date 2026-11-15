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
  final int dayOfMonth;

  const AutoSaveRulesModel({
    this.enableSurplus = false,
    this.enableRoundup = false,
    this.percentageIncome = 0.0,
    this.dayOfMonth = 1,
  });

  factory AutoSaveRulesModel.fromJson(Map<String, dynamic> json) =>
      _$AutoSaveRulesModelFromJson(json);
  Map<String, dynamic> toJson() => _$AutoSaveRulesModelToJson(this);

  @override
  List<Object?> get props => [
    enableSurplus,
    enableRoundup,
    percentageIncome,
    dayOfMonth,
  ];
}

@JsonSerializable()
class GoalContributionModel extends Equatable {
  @JsonKey(name: '_id', fromJson: GoalModel._idFromJson)
  final String id;
  // Nullable : les contributions enregistrées avant l'introduction du
  // partage n'ont pas d'auteur attribué côté serveur.
  final String? userId;
  final double amount;
  final DateTime date;
  final String? note;
  // 'contribution' ou 'redemption' : une entrée d'historique unique pour
  // tout ce qui est entré et sorti du pot, pas seulement les dépôts.
  @JsonKey(defaultValue: 'contribution')
  final String type;

  const GoalContributionModel({
    required this.id,
    this.userId,
    required this.amount,
    required this.date,
    this.note,
    this.type = 'contribution',
  });

  factory GoalContributionModel.fromJson(Map<String, dynamic> json) =>
      _$GoalContributionModelFromJson(json);
  Map<String, dynamic> toJson() => _$GoalContributionModelToJson(this);

  @override
  List<Object?> get props => [id, userId, amount, date, note, type];
}

@JsonSerializable()
class GoalParticipantModel extends Equatable {
  @JsonKey(name: '_id', fromJson: GoalModel._idFromJson)
  final String id;
  // Contrairement à BudgetParticipantModel, on expose aussi `userId` : il
  // faut pouvoir relier une contribution de l'historique (GoalContributionModel.userId)
  // à son auteur dans la liste des participants.
  final String userId;
  final String displayName;
  final DateTime? joinedAt;

  const GoalParticipantModel({
    required this.id,
    required this.userId,
    required this.displayName,
    this.joinedAt,
  });

  factory GoalParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$GoalParticipantModelFromJson(json);
  Map<String, dynamic> toJson() => _$GoalParticipantModelToJson(this);

  @override
  List<Object?> get props => [id, userId, displayName, joinedAt];
}

@JsonSerializable()
class GoalModel extends Equatable {
  @JsonKey(name: '_id', fromJson: _idFromJson)
  final String id;
  final String name;
  final String? description;
  final String? emoji;
  final String type; // 'emergency', 'savings', 'investment', 'debt'
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
  @JsonKey(defaultValue: false)
  final bool isShared;
  final String? inviteCode;
  @JsonKey(defaultValue: true)
  final bool isOwner;
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
    this.inviteCode,
    this.isOwner = true,
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

  /// Pénalité de sortie anticipée (0,5 %) que l'API retient quand on SUPPRIME
  /// ou RETIRE un objectif avant son échéance sans l'avoir atteint
  /// (GoalService.deleteGoal / redeemGoal). 0 sinon. Sert à prévenir
  /// l'utilisateur AVANT qu'il ne confirme : la boîte de suppression n'en
  /// parlait pas et l'argent était retenu sans avertissement.
  double earlyExitPenalty([DateTime? now]) {
    final at = now ?? DateTime.now();
    final reached = status == 'completed' || currentAmount >= targetAmount;
    if (currentAmount <= 0 || reached || !at.isBefore(deadline)) return 0;
    return (currentAmount * 0.005 * 100).round() / 100;
  }

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
    String? inviteCode,
    bool? isOwner,
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
      inviteCode: inviteCode ?? this.inviteCode,
      isOwner: isOwner ?? this.isOwner,
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
    inviteCode,
    isOwner,
    image,
    createdAt,
    updatedAt,
  ];
}
