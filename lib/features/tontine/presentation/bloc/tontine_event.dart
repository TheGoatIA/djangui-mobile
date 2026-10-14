import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class TontineEvent extends Equatable {
  const TontineEvent();

  @override
  List<Object?> get props => [];
}

class TontinesLoadRequested extends TontineEvent {}

class TontineDetailsLoadRequested extends TontineEvent {
  final String tontineId;
  const TontineDetailsLoadRequested(this.tontineId);

  @override
  List<Object?> get props => [tontineId];
}

class CreateTontineRequested extends TontineEvent {
  final Map<String, dynamic> params;
  const CreateTontineRequested(this.params);

  @override
  List<Object?> get props => [params];
}

class JoinTontineRequested extends TontineEvent {
  final String inviteCode;
  final String displayName;
  final int parts;
  const JoinTontineRequested({
    required this.inviteCode,
    required this.displayName,
    required this.parts,
  });

  @override
  List<Object?> get props => [inviteCode, displayName, parts];
}

class PaySocialFundRequested extends TontineEvent {
  final String tontineId;
  const PaySocialFundRequested(this.tontineId);

  @override
  List<Object?> get props => [tontineId];
}

class StartTontineRequested extends TontineEvent {
  final String tontineId;
  const StartTontineRequested(this.tontineId);

  @override
  List<Object?> get props => [tontineId];
}

class ContributeToTontineRequested extends TontineEvent {
  final String tontineId;
  final File proofImage;
  const ContributeToTontineRequested({
    required this.tontineId,
    required this.proofImage,
  });

  @override
  List<Object?> get props => [tontineId, proofImage];
}

class TontineMessagesLoadRequested extends TontineEvent {
  final String tontineId;
  const TontineMessagesLoadRequested(this.tontineId);

  @override
  List<Object?> get props => [tontineId];
}

class SendTontineMessageRequested extends TontineEvent {
  final String tontineId;
  final String content;
  const SendTontineMessageRequested({
    required this.tontineId,
    required this.content,
  });

  @override
  List<Object?> get props => [tontineId, content];
}

class SendTontineVoiceMessageRequested extends TontineEvent {
  final String tontineId;
  final File audioFile;
  final int durationSeconds;
  const SendTontineVoiceMessageRequested({
    required this.tontineId,
    required this.audioFile,
    required this.durationSeconds,
  });

  @override
  List<Object?> get props => [tontineId, audioFile, durationSeconds];
}

class TontineContributionsLoadRequested extends TontineEvent {
  final String tontineId;
  const TontineContributionsLoadRequested(this.tontineId);

  @override
  List<Object?> get props => [tontineId];
}

class ValidateTontineContributionRequested extends TontineEvent {
  final String tontineId;
  final String contributionId;
  final String status;
  const ValidateTontineContributionRequested({
    required this.tontineId,
    required this.contributionId,
    required this.status,
  });

  @override
  List<Object?> get props => [tontineId, contributionId, status];
}

class TontineRemoveMemberRequested extends TontineEvent {
  final String tontineId;
  final String memberId;
  const TontineRemoveMemberRequested({
    required this.tontineId,
    required this.memberId,
  });

  @override
  List<Object?> get props => [tontineId, memberId];
}

class DeleteTontineRequested extends TontineEvent {
  final String tontineId;
  const DeleteTontineRequested(this.tontineId);

  @override
  List<Object?> get props => [tontineId];
}

class UpdateTontineRequested extends TontineEvent {
  final String tontineId;
  final Map<String, dynamic> params;
  const UpdateTontineRequested(this.tontineId, this.params);

  @override
  List<Object?> get props => [tontineId, params];
}

class RotateTurnRequested extends TontineEvent {
  final String tontineId;
  const RotateTurnRequested(this.tontineId);

  @override
  List<Object?> get props => [tontineId];
}

class ToggleAutoDebitRequested extends TontineEvent {
  final String tontineId;
  final bool enabled;
  const ToggleAutoDebitRequested({
    required this.tontineId,
    required this.enabled,
  });

  @override
  List<Object?> get props => [tontineId, enabled];
}

class ResetTontineRequested extends TontineEvent {
  const ResetTontineRequested();
}
