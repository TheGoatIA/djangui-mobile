import 'package:equatable/equatable.dart';

abstract class FintechEvent extends Equatable {
  const FintechEvent();

  @override
  List<Object?> get props => [];
}

class FetchWalletBalance extends FintechEvent {}

class FetchWalletTransactions extends FintechEvent {}

class RequestWithdrawal extends FintechEvent {
  final double amount;
  final String phoneNumber;
  final String provider;

  const RequestWithdrawal({
    required this.amount,
    required this.phoneNumber,
    required this.provider,
  });

  @override
  List<Object?> get props => [amount, phoneNumber, provider];
}

class DownloadReceipt extends FintechEvent {
  final String transactionId;

  const DownloadReceipt({required this.transactionId});

  @override
  List<Object?> get props => [transactionId];
}
