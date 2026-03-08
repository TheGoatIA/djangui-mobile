import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'challenge_model.g.dart';

@JsonSerializable()
class ChallengeModel extends Equatable {
  @JsonKey(name: '_id', fromJson: _idFromJson)
  final String id;
  final String title;
  final String description;
  final String type; // saving, spending_cut, habit
  final String difficulty; // easy, medium, hard
  final double? targetAmount;
  final int durationDays;
  final int rewardPoints;
  final String? icon;
  final bool? requiresProof; // Nouveau : Preuve photo requise

  static String _idFromJson(dynamic id) {
    if (id is Map) return id['\$oid'] ?? id['_id'] ?? id['id'] ?? '';
    return id?.toString() ?? '';
  }

  const ChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.targetAmount,
    required this.durationDays,
    required this.rewardPoints,
    this.icon,
    this.requiresProof = false,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    final data = json['request'] ?? json;
    return _$ChallengeModelFromJson(data as Map<String, dynamic>);
  }
  Map<String, dynamic> toJson() => _$ChallengeModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    type,
    difficulty,
    targetAmount,
    rewardPoints,
    icon,
    requiresProof,
  ];
}

@JsonSerializable()
class UserChallengeModel extends Equatable {
  @JsonKey(name: '_id', fromJson: _idFromJson)
  final String id;
  final String status;
  final double progress;
  final double currentValue;

  @_ChallengeIdConverter()
  final ChallengeModel? challengeId;
  final ChallengeFlexibilityModel?
  flexibility; // Mis à jour pour utiliser un modèle
  final List<ChallengeWeekModel>? weeks;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  static String _idFromJson(dynamic id) {
    if (id is Map) return id['\$oid'] ?? id['_id'] ?? id['id'] ?? '';
    return id?.toString() ?? '';
  }

  const UserChallengeModel({
    required this.id,
    required this.status,
    required this.progress,
    required this.currentValue,
    this.challengeId,
    this.flexibility,
    this.weeks,
    this.createdAt,
    this.updatedAt,
  });

  factory UserChallengeModel.fromJson(Map<String, dynamic> json) {
    final data = json['request'] ?? json;
    return _$UserChallengeModelFromJson(data as Map<String, dynamic>);
  }
  Map<String, dynamic> toJson() => _$UserChallengeModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    status,
    progress,
    currentValue,
    challengeId,
    flexibility,
    weeks,
    createdAt,
    updatedAt,
  ];
}

@JsonSerializable()
class ChallengeWeekModel extends Equatable {
  @JsonKey(name: '_id', fromJson: _idFromJson)
  final String id;
  final int weekNumber;
  final double targetAmount;
  final double savedAmount;
  final String status;

  static String _idFromJson(dynamic id) {
    if (id is Map) return id['\$oid'] ?? id['_id'] ?? id['id'] ?? '';
    return id?.toString() ?? '';
  }

  const ChallengeWeekModel({
    required this.id,
    required this.weekNumber,
    required this.targetAmount,
    required this.savedAmount,
    required this.status,
  });

  factory ChallengeWeekModel.fromJson(Map<String, dynamic> json) {
    final data = json['request'] ?? json;
    return _$ChallengeWeekModelFromJson(data as Map<String, dynamic>);
  }
  Map<String, dynamic> toJson() => _$ChallengeWeekModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    weekNumber,
    targetAmount,
    savedAmount,
    status,
  ];
}

@JsonSerializable()
class ChallengeFlexibilityModel extends Equatable {
  final int skipsUsed;
  final int maxSkips;
  final int postponementsUsed;
  final DateTime? nextDeadline;

  const ChallengeFlexibilityModel({
    this.skipsUsed = 0,
    this.maxSkips = 3,
    this.postponementsUsed = 0,
    this.nextDeadline,
  });

  factory ChallengeFlexibilityModel.fromJson(Map<String, dynamic> json) =>
      _$ChallengeFlexibilityModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChallengeFlexibilityModelToJson(this);

  @override
  List<Object?> get props => [
    skipsUsed,
    maxSkips,
    postponementsUsed,
    nextDeadline,
  ];
}

@JsonSerializable()
class ChallengeProofModel extends Equatable {
  @JsonKey(name: '_id', fromJson: _idFromJson)
  final String id;
  final String imageUrl;
  final String status; // pending, approved, rejected
  final DateTime createdAt;

  static String _idFromJson(dynamic id) {
    if (id is Map) return id['\$oid'] ?? id['_id'] ?? id['id'] ?? '';
    return id?.toString() ?? '';
  }

  const ChallengeProofModel({
    required this.id,
    required this.imageUrl,
    required this.status,
    required this.createdAt,
  });

  factory ChallengeProofModel.fromJson(Map<String, dynamic> json) =>
      _$ChallengeProofModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChallengeProofModelToJson(this);

  @override
  List<Object?> get props => [id, imageUrl, status, createdAt];
}

@JsonSerializable()
class ChallengeRedeemModel extends Equatable {
  final double redeemedAmount;
  final UserChallengeModel userChallenge;

  const ChallengeRedeemModel({
    required this.redeemedAmount,
    required this.userChallenge,
  });

  factory ChallengeRedeemModel.fromJson(Map<String, dynamic> json) {
    return ChallengeRedeemModel(
      redeemedAmount: (json['redeemedAmount'] as num).toDouble(),
      userChallenge: UserChallengeModel.fromJson(
        json['userChallenge'] as Map<String, dynamic>,
      ),
    );
  }
  Map<String, dynamic> toJson() => {
    'redeemedAmount': redeemedAmount,
    'userChallenge': userChallenge.toJson(),
  };

  @override
  List<Object?> get props => [redeemedAmount, userChallenge];
}

class _ChallengeIdConverter implements JsonConverter<ChallengeModel?, dynamic> {
  const _ChallengeIdConverter();

  @override
  ChallengeModel? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is Map<String, dynamic>) {
      return ChallengeModel.fromJson(json);
    }
    if (json is String) {
      // If it's just an ID, we return a skeleton model so that we can still access the ID
      return ChallengeModel(
        id: json,
        title: '',
        description: '',
        type: '',
        difficulty: '',
        targetAmount: null,
        durationDays: 0,
        rewardPoints: 0,
      );
    }
    return null;
  }

  @override
  dynamic toJson(ChallengeModel? object) => object?.toJson();
}
