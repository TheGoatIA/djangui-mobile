import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kauri/core/analytics/analytics_service.dart';
import 'package:kauri/di/injection.dart';
import '../../domain/repositories/fintech_repository.dart';
import 'fintech_event.dart';
import 'fintech_state.dart';

@lazySingleton
class FintechBloc extends Bloc<FintechEvent, FintechState> {
  final FintechRepository _repository;
  AnalyticsService get _analytics => getIt<AnalyticsService>();

  FintechBloc(this._repository) : super(const FintechState()) {
    on<FetchWalletBalance>(_onFetchWalletBalance);
    on<FetchWalletTransactions>(_onFetchWalletTransactions);
    on<RequestWithdrawal>(_onRequestWithdrawal);
    on<DownloadReceipt>(_onDownloadReceipt);
    on<DownloadPaymentReceipt>(_onDownloadPaymentReceipt);
    on<ClearFintechData>(_onClearFintechData);
  }

  Future<void> _onClearFintechData(
    ClearFintechData event,
    Emitter<FintechState> emit,
  ) async {
    // Reset to default initial state
    emit(const FintechState());
  }

  Future<void> _onFetchWalletBalance(
    FetchWalletBalance event,
    Emitter<FintechState> emit,
  ) async {
    emit(state.copyWith(status: FintechStatus.loading));
    final result = await _repository.getWalletBalance();
    result.fold(
      (failure) => emit(
        state.copyWith(status: FintechStatus.error, message: failure.message),
      ),
      (balance) =>
          emit(state.copyWith(status: FintechStatus.success, balance: balance)),
    );
  }

  Future<void> _onFetchWalletTransactions(
    FetchWalletTransactions event,
    Emitter<FintechState> emit,
  ) async {
    emit(state.copyWith(status: FintechStatus.loading));
    final result = await _repository.getWalletTransactions();
    result.fold(
      (failure) => emit(
        state.copyWith(status: FintechStatus.error, message: failure.message),
      ),
      (transactions) => emit(
        state.copyWith(
          status: FintechStatus.success,
          transactions: transactions,
        ),
      ),
    );
  }

  Future<void> _onRequestWithdrawal(
    RequestWithdrawal event,
    Emitter<FintechState> emit,
  ) async {
    final startMs = DateTime.now().millisecondsSinceEpoch;
    _analytics.logWithdrawalInitiated(
      currency: 'XAF',
      amount: event.amount,
      provider: event.provider,
    );
    emit(state.copyWith(status: FintechStatus.loading));
    final result = await _repository.requestPayout(
      amount: event.amount,
      phoneNumber: event.phoneNumber,
      provider: event.provider,
    );
    result.fold(
      (failure) {
        _analytics.logWithdrawalFailed(
          reason: failure.message,
          provider: event.provider,
        );
        emit(
          state.copyWith(
            status: FintechStatus.withdrawalError,
            message: failure.message,
          ),
        );
        add(FetchWalletBalance());
        add(FetchWalletTransactions());
      },
      (message) {
        _analytics.logWithdrawalCompleted(
          currency: 'XAF',
          amount: event.amount,
          provider: event.provider,
          durationMs: DateTime.now().millisecondsSinceEpoch - startMs,
        );
        emit(
          state.copyWith(
            status: FintechStatus.withdrawalSuccess,
            message: message,
          ),
        );
        add(FetchWalletBalance());
        add(FetchWalletTransactions());
      },
    );
  }

  Future<void> _onDownloadReceipt(
    DownloadReceipt event,
    Emitter<FintechState> emit,
  ) async {
    emit(
      state.copyWith(
        status: FintechStatus.loadingReceipt,
        downloadingReceiptId: event.transactionId,
      ),
    );
    final result = await _repository.getInvoicePdfUrl(event.transactionId);

    if (result.isRight()) {
      // Petite pause pour laisser au serveur le temps de finaliser/sauvegarder le PDF
      await Future.delayed(const Duration(seconds: 2));
    }

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FintechStatus.receiptError,
          message: failure.message,
          clearDownloadingReceiptId: true,
        ),
      ),
      (url) => emit(
        state.copyWith(
          status: FintechStatus.receiptReady,
          message: url,
          clearDownloadingReceiptId: true,
        ),
      ),
    );
  }

  Future<void> _onDownloadPaymentReceipt(
    DownloadPaymentReceipt event,
    Emitter<FintechState> emit,
  ) async {
    emit(
      state.copyWith(
        status: FintechStatus.loadingReceipt,
        downloadingReceiptId: event.paymentId,
      ),
    );
    final result = await _repository.getPaymentInvoicePdfUrl(event.paymentId);

    if (result.isRight()) {
      // Petite pause pour laisser au serveur le temps de finaliser/sauvegarder le PDF
      await Future.delayed(const Duration(seconds: 2));
    }

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FintechStatus.receiptError,
          message: failure.message,
          clearDownloadingReceiptId: true,
        ),
      ),
      (url) => emit(
        state.copyWith(
          status: FintechStatus.receiptReady,
          message: url,
          clearDownloadingReceiptId: true,
        ),
      ),
    );
  }
}
