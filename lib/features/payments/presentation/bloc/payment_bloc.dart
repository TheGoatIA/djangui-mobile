import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kauri/core/analytics/analytics_service.dart';
import 'package:kauri/di/injection.dart';
import '../../domain/repositories/payment_repository.dart';
import 'payment_event.dart';
import 'payment_state.dart';

@lazySingleton
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _repository;
  AnalyticsService get _analytics => getIt<AnalyticsService>();

  PaymentBloc(this._repository) : super(PaymentInitial()) {
    on<InitNotchPayPayment>(_onInitNotchPay);
    on<InitStripeCheckout>(_onInitStripe);
    on<VerifyPayment>(_onVerifyPayment);
  }

  Future<void> _onInitNotchPay(
    InitNotchPayPayment event,
    Emitter<PaymentState> emit,
  ) async {
    _analytics.logDepositInitiated(
      paymentMethod: 'notchpay',
      currency: 'XAF',
      amount: event.amount,
      provider: 'notchpay',
    );
    emit(PaymentLoading());
    final result = await _repository.initNotchPayPayment(
      amount: event.amount,
      phone: event.phone,
    );
    result.fold(
      (failure) {
        _analytics.logDepositFailed(
          paymentMethod: 'notchpay',
          reason: failure.message,
          provider: 'notchpay',
        );
        emit(PaymentError(failure.message));
      },
      (response) {
        // Pas de « dépôt réalisé » ici : la page de paiement vient seulement
        // d'être ouverte (l'utilisateur peut abandonner). Le dépôt n'est réel
        // qu'à la confirmation (webhook côté serveur / VerifyPayment) — l'ancien
        // événement gonflait les statistiques de dépôts.
        emit(PaymentSuccess(response));
      },
    );
  }

  Future<void> _onInitStripe(
    InitStripeCheckout event,
    Emitter<PaymentState> emit,
  ) async {
    _analytics.logDepositInitiated(
      paymentMethod: 'stripe',
      currency: event.currency,
      amount: event.amount,
      provider: 'stripe',
    );
    emit(PaymentLoading());
    final result = await _repository.initStripeCheckout(
      amount: event.amount,
      currency: event.currency,
    );
    result.fold(
      (failure) {
        _analytics.logDepositFailed(
          paymentMethod: 'stripe',
          reason: failure.message,
          provider: 'stripe',
        );
        emit(PaymentError(failure.message));
      },
      (response) {
        // Pas de « dépôt réalisé » ici : la page de paiement vient seulement
        // d'être ouverte (l'utilisateur peut abandonner). Le dépôt n'est réel
        // qu'à la confirmation (webhook côté serveur / VerifyPayment) — l'ancien
        // événement gonflait les statistiques de dépôts.
        emit(PaymentSuccess(response));
      },
    );
  }

  Future<void> _onVerifyPayment(
    VerifyPayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await _repository.verifyPayment(event.reference);
    result.fold((failure) => emit(PaymentError(failure.message)), (data) {
      final status = (data['status'] ?? data['payment']?['status'])?.toString();
      if (status == 'completed') {
        final amount =
            (data['amount'] ?? data['payment']?['amount']) as num? ?? 0;
        _analytics.logDepositCompleted(
          paymentMethod: (data['provider'] ?? 'unknown').toString(),
          currency: (data['currency'] ?? 'XAF').toString(),
          amount: amount,
        );
      }
      emit(PaymentVerified(data));
    });
  }
}
