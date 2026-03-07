import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class InitNotchPayPayment extends PaymentEvent {
  final double amount;
  final String phone;

  const InitNotchPayPayment({required this.amount, required this.phone});

  @override
  List<Object> get props => [amount, phone];
}

class InitStripeCheckout extends PaymentEvent {
  final double amount;
  final String currency;

  const InitStripeCheckout({required this.amount, required this.currency});

  @override
  List<Object> get props => [amount, currency];
}

class VerifyPayment extends PaymentEvent {
  final String reference;

  const VerifyPayment(this.reference);

  @override
  List<Object> get props => [reference];
}
