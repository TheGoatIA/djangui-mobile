import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/payment_repository.dart';
import 'payment_event.dart';
import 'payment_state.dart';

@injectable
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _repository;

  PaymentBloc(this._repository) : super(PaymentInitial()) {
    on<InitNotchPayPayment>(_onInitNotchPay);
    on<InitStripeCheckout>(_onInitStripe);
    on<VerifyPayment>(_onVerifyPayment);
  }

  Future<void> _onInitNotchPay(
    InitNotchPayPayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await _repository.initNotchPayPayment(
      amount: event.amount,
      phone: event.phone,
    );
    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (response) => emit(PaymentSuccess(response)),
    );
  }

  Future<void> _onInitStripe(
    InitStripeCheckout event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await _repository.initStripeCheckout(
      amount: event.amount,
      currency: event.currency,
    );
    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (response) => emit(PaymentSuccess(response)),
    );
  }

  Future<void> _onVerifyPayment(
    VerifyPayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await _repository.verifyPayment(event.reference);
    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (data) => emit(PaymentVerified(data)),
    );
  }
}
