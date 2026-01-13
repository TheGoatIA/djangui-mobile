import 'package:json_annotation/json_annotation.dart';

part 'tontine_model.g.dart';

@JsonSerializable()
class TontineModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String frequency;
  final double contributionAmount;
  final int totalParts;
  final String currency;
  final String rotationMode;
  final String validationMode;
  final Map<String, dynamic> sanctions;
  final List<Map<String, dynamic>>? escrowDetails;
  final Map<String, dynamic> socialFund;
  final String status;
  final String inviteCode;
  final int currentTurn;
  @JsonKey(fromJson: _idFromMapOrString)
  final String creatorId;
  final DateTime? startDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? autoRenew;
  final bool? rulesAcceptedByAll;
  final TurnSummaryModel? turnSummary;

  TontineModel({
    required this.id,
    required this.name,
    required this.frequency,
    required this.contributionAmount,
    required this.totalParts,
    required this.currency,
    required this.rotationMode,
    required this.validationMode,
    required this.sanctions,
    this.escrowDetails,
    required this.socialFund,
    required this.status,
    required this.inviteCode,
    required this.currentTurn,
    required this.creatorId,
    this.startDate,
    this.createdAt,
    this.updatedAt,
    this.autoRenew,
    this.rulesAcceptedByAll,
    this.turnSummary,
  });

  factory TontineModel.fromJson(Map<String, dynamic> json) =>
      _$TontineModelFromJson(json);
  Map<String, dynamic> toJson() => _$TontineModelToJson(this);
}

@JsonSerializable()
class TontineMemberModel {
  @JsonKey(name: '_id')
  final String id;
  final String tontineId;
  @JsonKey(fromJson: _idFromMapOrString)
  final String userId;
  final String displayName;
  final int parts;
  final double trustScore;
  final bool hasPaidSocialFund;
  final String? payoutDetails;

  TontineMemberModel({
    required this.id,
    required this.tontineId,
    required this.userId,
    required this.displayName,
    required this.parts,
    required this.trustScore,
    required this.hasPaidSocialFund,
    this.payoutDetails,
  });

  factory TontineMemberModel.fromJson(Map<String, dynamic> json) =>
      _$TontineMemberModelFromJson(json);
  Map<String, dynamic> toJson() => _$TontineMemberModelToJson(this);
}

@JsonSerializable()
class TontineContributionModel {
  @JsonKey(name: '_id')
  final String id;
  final String tontineId;
  @JsonKey(fromJson: _idFromMapOrString)
  final String memberId;
  final int turnIndex;
  final double amountPaid;
  final String proofImage; // URL
  final String
  validationStatus; // pending, ai_validated, creator_validated, rejected
  final Map<String, dynamic>?
  aiAnalysis; // {detectedRef, detectedAmount, detectedDate, confidence}
  final DateTime createdAt;

  TontineContributionModel({
    required this.id,
    required this.tontineId,
    required this.memberId,
    required this.turnIndex,
    required this.amountPaid,
    required this.proofImage,
    required this.validationStatus,
    this.aiAnalysis,
    required this.createdAt,
  });

  factory TontineContributionModel.fromJson(Map<String, dynamic> json) =>
      _$TontineContributionModelFromJson(json);
  Map<String, dynamic> toJson() => _$TontineContributionModelToJson(this);
}

@JsonSerializable()
class TontineMessageModel {
  @JsonKey(name: '_id')
  final String id;
  final String tontineId;
  @JsonKey(fromJson: _idFromMapOrString)
  final String senderId;
  final String content;
  final DateTime createdAt;

  TontineMessageModel({
    required this.id,
    required this.tontineId,
    required this.senderId,
    required this.content,
    required this.createdAt,
  });

  factory TontineMessageModel.fromJson(Map<String, dynamic> json) =>
      _$TontineMessageModelFromJson(json);
  Map<String, dynamic> toJson() => _$TontineMessageModelToJson(this);
}

@JsonSerializable()
class TurnSummaryModel {
  final double collectedAmount;
  final double expectedAmount;
  final int contributorsCount;
  final int totalMembers;

  TurnSummaryModel({
    required this.collectedAmount,
    required this.expectedAmount,
    required this.contributorsCount,
    required this.totalMembers,
  });

  factory TurnSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$TurnSummaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$TurnSummaryModelToJson(this);
}

String _idFromMapOrString(dynamic value) {
  if (value is Map) {
    return (value['_id'] ?? value['id']).toString();
  }
  return value.toString();
}
