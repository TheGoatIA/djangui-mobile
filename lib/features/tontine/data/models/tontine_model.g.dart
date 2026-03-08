// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tontine_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TontineModel _$TontineModelFromJson(Map<String, dynamic> json) => TontineModel(
  id: json['_id'] as String,
  name: json['name'] as String,
  frequency: json['frequency'] as String,
  contributionAmount: (json['contributionAmount'] as num).toDouble(),
  totalParts: (json['totalParts'] as num).toInt(),
  currency: json['currency'] as String,
  rotationMode: json['rotationMode'] as String,
  validationMode: json['validationMode'] as String,
  sanctions: json['sanctions'] as Map<String, dynamic>,
  escrowDetails: (json['escrowDetails'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
  socialFund: json['socialFund'] as Map<String, dynamic>,
  status: json['status'] as String,
  inviteCode: json['inviteCode'] as String,
  currentTurn: (json['currentTurn'] as num).toInt(),
  creatorId: _idFromMapOrString(json['creatorId']),
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  autoRenew: json['autoRenew'] as bool?,
  deadline: json['deadline'] == null
      ? null
      : DateTime.parse(json['deadline'] as String),
  rulesAcceptedByAll: json['rulesAcceptedByAll'] as bool?,
  turnSummary: json['turnSummary'] == null
      ? null
      : TurnSummaryModel.fromJson(json['turnSummary'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TontineModelToJson(TontineModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'frequency': instance.frequency,
      'contributionAmount': instance.contributionAmount,
      'totalParts': instance.totalParts,
      'currency': instance.currency,
      'rotationMode': instance.rotationMode,
      'validationMode': instance.validationMode,
      'sanctions': instance.sanctions,
      'escrowDetails': instance.escrowDetails,
      'socialFund': instance.socialFund,
      'status': instance.status,
      'inviteCode': instance.inviteCode,
      'currentTurn': instance.currentTurn,
      'creatorId': instance.creatorId,
      'startDate': instance.startDate?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'autoRenew': instance.autoRenew,
      'deadline': instance.deadline?.toIso8601String(),
      'rulesAcceptedByAll': instance.rulesAcceptedByAll,
      'turnSummary': instance.turnSummary,
    };

TontineMemberModel _$TontineMemberModelFromJson(Map<String, dynamic> json) =>
    TontineMemberModel(
      id: json['_id'] as String,
      tontineId: json['tontineId'] as String,
      userId: _idFromMapOrString(json['userId']),
      displayName: json['displayName'] as String,
      parts: (json['parts'] as num).toInt(),
      trustScore: (json['trustScore'] as num).toDouble(),
      hasPaidSocialFund: json['hasPaidSocialFund'] as bool,
      autoDebitEnabled: json['autoDebitEnabled'] as bool? ?? false,
      payoutDetails: json['payoutDetails'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$TontineMemberModelToJson(TontineMemberModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'tontineId': instance.tontineId,
      'userId': instance.userId,
      'displayName': instance.displayName,
      'parts': instance.parts,
      'trustScore': instance.trustScore,
      'hasPaidSocialFund': instance.hasPaidSocialFund,
      'autoDebitEnabled': instance.autoDebitEnabled,
      'payoutDetails': instance.payoutDetails,
    };

TontineContributionModel _$TontineContributionModelFromJson(
  Map<String, dynamic> json,
) => TontineContributionModel(
  id: json['_id'] as String,
  tontineId: json['tontineId'] as String,
  memberId: _idFromMapOrString(json['memberId']),
  turnIndex: (json['turnIndex'] as num).toInt(),
  amountPaid: (json['amountPaid'] as num).toDouble(),
  proofImage: json['proofImage'] as String,
  validationStatus: json['validationStatus'] as String,
  aiAnalysis: json['aiAnalysis'] as Map<String, dynamic>?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$TontineContributionModelToJson(
  TontineContributionModel instance,
) => <String, dynamic>{
  '_id': instance.id,
  'tontineId': instance.tontineId,
  'memberId': instance.memberId,
  'turnIndex': instance.turnIndex,
  'amountPaid': instance.amountPaid,
  'proofImage': instance.proofImage,
  'validationStatus': instance.validationStatus,
  'aiAnalysis': instance.aiAnalysis,
  'createdAt': instance.createdAt.toIso8601String(),
};

TontineMessageModel _$TontineMessageModelFromJson(Map<String, dynamic> json) =>
    TontineMessageModel(
      id: json['_id'] as String,
      tontineId: json['tontineId'] as String,
      senderId: _idFromMapOrString(json['senderId']),
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$TontineMessageModelToJson(
  TontineMessageModel instance,
) => <String, dynamic>{
  '_id': instance.id,
  'tontineId': instance.tontineId,
  'senderId': instance.senderId,
  'content': instance.content,
  'createdAt': instance.createdAt.toIso8601String(),
};

TurnSummaryModel _$TurnSummaryModelFromJson(Map<String, dynamic> json) =>
    TurnSummaryModel(
      collectedAmount: (json['collectedAmount'] as num).toDouble(),
      expectedAmount: (json['expectedAmount'] as num).toDouble(),
      contributorsCount: (json['contributorsCount'] as num).toInt(),
      totalMembers: (json['totalMembers'] as num).toInt(),
    );

Map<String, dynamic> _$TurnSummaryModelToJson(TurnSummaryModel instance) =>
    <String, dynamic>{
      'collectedAmount': instance.collectedAmount,
      'expectedAmount': instance.expectedAmount,
      'contributorsCount': instance.contributorsCount,
      'totalMembers': instance.totalMembers,
    };
