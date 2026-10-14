import 'package:equatable/equatable.dart';

class Tontine extends Equatable {
  final String id;
  final String name;
  final String frequency;
  final double contributionAmount;
  final int totalParts;
  final String currency;
  final String rotationMode;
  final String validationMode;
  final Map<String, dynamic> sanctions;
  final Map<String, dynamic> socialFund;
  final String status;
  final String inviteCode;
  final int currentTurn;
  final String creatorId;
  final DateTime? startDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? autoRenew;
  final DateTime? deadline;
  final bool? rulesAcceptedByAll;
  final TurnSummary? turnSummary;

  const Tontine({
    required this.id,
    required this.name,
    required this.frequency,
    required this.contributionAmount,
    required this.totalParts,
    required this.currency,
    required this.rotationMode,
    required this.validationMode,
    required this.sanctions,
    required this.socialFund,
    required this.status,
    required this.inviteCode,
    required this.currentTurn,
    required this.creatorId,
    this.startDate,
    this.createdAt,
    this.updatedAt,
    this.autoRenew,
    this.deadline,
    this.rulesAcceptedByAll,
    this.turnSummary,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    frequency,
    contributionAmount,
    totalParts,
    currency,
    rotationMode,
    validationMode,
    sanctions,
    socialFund,
    status,
    inviteCode,
    currentTurn,
    creatorId,
    startDate,
    createdAt,
    updatedAt,
    autoRenew,
    deadline,
    rulesAcceptedByAll,
    turnSummary,
  ];
}

class TontineMember extends Equatable {
  final String id;
  final String tontineId;
  final String userId;
  final String displayName;
  final int parts;
  final double trustScore;
  final bool hasPaidSocialFund;
  final bool autoDebitEnabled;

  const TontineMember({
    required this.id,
    required this.tontineId,
    required this.userId,
    required this.displayName,
    required this.parts,
    required this.trustScore,
    required this.hasPaidSocialFund,
    this.autoDebitEnabled = false,
  });

  @override
  List<Object?> get props => [
    id,
    tontineId,
    userId,
    displayName,
    parts,
    trustScore,
    hasPaidSocialFund,
    autoDebitEnabled,
  ];
}

class TontineContribution extends Equatable {
  final String id;
  final String tontineId;
  final String memberId;
  final int turnIndex;
  final double amountPaid;
  final String proofImage;
  final String validationStatus;
  final Map<String, dynamic>? aiAnalysis;
  final DateTime createdAt;

  const TontineContribution({
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

  @override
  List<Object?> get props => [
    id,
    tontineId,
    memberId,
    turnIndex,
    amountPaid,
    proofImage,
    validationStatus,
    aiAnalysis,
    createdAt,
  ];
}

class TontineMessage extends Equatable {
  final String id;
  final String tontineId;
  final String senderId;
  final String content;
  final String type;
  final String? audioUrl;
  final int? audioDuration;
  final DateTime createdAt;

  const TontineMessage({
    required this.id,
    required this.tontineId,
    required this.senderId,
    required this.content,
    this.type = 'text',
    this.audioUrl,
    this.audioDuration,
    required this.createdAt,
  });

  @override
  List<Object?> get props =>
      [id, tontineId, senderId, content, type, audioUrl, audioDuration, createdAt];
}

class TurnSummary extends Equatable {
  final double collectedAmount;
  final double expectedAmount;
  final int contributorsCount;
  final int totalMembers;
  final DateTime? deadline;
  final String? currentBeneficiaryId;
  final String? currentBeneficiaryName;

  const TurnSummary({
    required this.collectedAmount,
    required this.expectedAmount,
    required this.contributorsCount,
    required this.totalMembers,
    this.deadline,
    this.currentBeneficiaryId,
    this.currentBeneficiaryName,
  });

  @override
  List<Object?> get props => [
    collectedAmount,
    expectedAmount,
    contributorsCount,
    totalMembers,
    deadline,
    currentBeneficiaryId,
    currentBeneficiaryName,
  ];
}
