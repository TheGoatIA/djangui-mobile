import 'package:equatable/equatable.dart';
import '../../data/models/fintech_models.dart';

enum FintechStatus {
  initial,
  loading,
  success,
  error,
  withdrawalSuccess,
  withdrawalError,
  loadingReceipt,
  receiptReady,
  receiptError,
}

class FintechState extends Equatable {
  final double balance;
  final List<FintechTransactionModel> transactions;
  final FintechStatus status;
  final String? message;
  final String? downloadingReceiptId;

  const FintechState({
    this.balance = 0.0,
    this.transactions = const [],
    this.status = FintechStatus.initial,
    this.message,
    this.downloadingReceiptId,
  });

  FintechState copyWith({
    double? balance,
    List<FintechTransactionModel>? transactions,
    FintechStatus? status,
    String? message,
    String? downloadingReceiptId,
    bool clearDownloadingReceiptId = false,
  }) {
    return FintechState(
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      status: status ?? this.status,
      message: message ?? this.message,
      downloadingReceiptId: clearDownloadingReceiptId
          ? null
          : (downloadingReceiptId ?? this.downloadingReceiptId),
    );
  }

  @override
  List<Object?> get props => [
    balance,
    transactions,
    status,
    message,
    downloadingReceiptId,
  ];
}
