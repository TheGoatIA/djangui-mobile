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
  // Distinct from `status` (which `FetchWalletBalance`/`FetchWalletTransactions`
  // also drive through `loading`/`success`, concurrently with a withdrawal
  // in flight) so the UI can show a withdrawal-specific loading popup without
  // it flickering on/off from unrelated background balance/transaction refreshes.
  final bool isProcessingWithdrawal;

  const FintechState({
    this.balance = 0.0,
    this.transactions = const [],
    this.status = FintechStatus.initial,
    this.message,
    this.downloadingReceiptId,
    this.isProcessingWithdrawal = false,
  });

  FintechState copyWith({
    double? balance,
    List<FintechTransactionModel>? transactions,
    FintechStatus? status,
    String? message,
    String? downloadingReceiptId,
    bool clearDownloadingReceiptId = false,
    bool? isProcessingWithdrawal,
  }) {
    return FintechState(
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      status: status ?? this.status,
      message: message ?? this.message,
      downloadingReceiptId: clearDownloadingReceiptId
          ? null
          : (downloadingReceiptId ?? this.downloadingReceiptId),
      isProcessingWithdrawal:
          isProcessingWithdrawal ?? this.isProcessingWithdrawal,
    );
  }

  @override
  List<Object?> get props => [
    balance,
    transactions,
    status,
    message,
    downloadingReceiptId,
    isProcessingWithdrawal,
  ];
}
