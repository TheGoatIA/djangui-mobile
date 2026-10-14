import 'package:equatable/equatable.dart';
import '../../data/models/reseller_models.dart';

abstract class ResellerState extends Equatable {
  const ResellerState();

  @override
  List<Object?> get props => [];
}

class ResellerInitial extends ResellerState {}

class ResellerLoading extends ResellerState {}

class ResellerLoaded extends ResellerState {
  final ResellerDashboardStatsModel stats;
  final List<ResellerAccountModel> accounts;

  const ResellerLoaded({required this.stats, required this.accounts});

  @override
  List<Object?> get props => [stats, accounts];
}

class ResellerVaultUnlocked extends ResellerState {
  final String email;
  final String password;
  final String pin;
  final String recoveryContact;
  final String secretNotes;

  const ResellerVaultUnlocked({
    required this.email,
    required this.password,
    required this.pin,
    required this.recoveryContact,
    required this.secretNotes,
  });

  @override
  List<Object?> get props => [
    email,
    password,
    pin,
    recoveryContact,
    secretNotes,
  ];
}

class ResellerActionSuccess extends ResellerState {
  final String message;
  const ResellerActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ResellerError extends ResellerState {
  final String message;
  const ResellerError(this.message);

  @override
  List<Object?> get props => [message];
}
