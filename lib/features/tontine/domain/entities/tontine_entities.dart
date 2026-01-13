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
  final List<Map<String, dynamic>>? escrowDetails;
  final Map<String, dynamic> socialFund;
  final String status;
  final String inviteCode;
  final int currentTurn;
  final String creatorId;
  final DateTime? startDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? autoRenew;
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
    escrowDetails,
    socialFund,
    status,
    inviteCode,
    currentTurn,
    creatorId,
    startDate,
    createdAt,
    updatedAt,
    autoRenew,
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
  final String? payoutDetails;

  const TontineMember({
    required this.id,
    required this.tontineId,
    required this.userId,
    required this.displayName,
    required this.parts,
    required this.trustScore,
    required this.hasPaidSocialFund,
    this.payoutDetails,
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
    payoutDetails,
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
  final DateTime createdAt;

  const TontineMessage({
    required this.id,
    required this.tontineId,
    required this.senderId,
    required this.content,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, tontineId, senderId, content, createdAt];
}

class TurnSummary extends Equatable {
  final double collectedAmount;
  final double expectedAmount;
  final int contributorsCount;
  final int totalMembers;

  const TurnSummary({
    required this.collectedAmount,
    required this.expectedAmount,
    required this.contributorsCount,
    required this.totalMembers,
  });

  @override
  List<Object?> get props => [
    collectedAmount,
    expectedAmount,
    contributorsCount,
    totalMembers,
  ];
}
