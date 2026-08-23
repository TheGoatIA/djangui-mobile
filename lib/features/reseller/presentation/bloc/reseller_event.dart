import 'package:equatable/equatable.dart';
abstract class ResellerEvent extends Equatable {
  const ResellerEvent();

  @override
  List<Object?> get props => [];
}

class FetchResellerDashboardRequested extends ResellerEvent {}

class CreateMasterAccountRequested extends ResellerEvent {
  final Map<String, dynamic> accountData;
  const CreateMasterAccountRequested(this.accountData);

  @override
  List<Object?> get props => [accountData];
}

class AddSlotToAccountRequested extends ResellerEvent {
  final String accountId;
  final Map<String, dynamic> slotData;
  const AddSlotToAccountRequested(this.accountId, this.slotData);

  @override
  List<Object?> get props => [accountId, slotData];
}

class RecordSlotPaymentRequested extends ResellerEvent {
  final String slotId;
  final Map<String, dynamic> paymentData;
  const RecordSlotPaymentRequested(this.slotId, this.paymentData);

  @override
  List<Object?> get props => [slotId, paymentData];
}

class UnlockVaultRequested extends ResellerEvent {
  final String accountId;
  const UnlockVaultRequested(this.accountId);

  @override
  List<Object?> get props => [accountId];
}

class DeleteSlotRequested extends ResellerEvent {
  final String slotId;
  const DeleteSlotRequested(this.slotId);

  @override
  List<Object?> get props => [slotId];
}

class DeleteMasterAccountRequested extends ResellerEvent {
  final String accountId;
  const DeleteMasterAccountRequested(this.accountId);

  @override
  List<Object?> get props => [accountId];
}