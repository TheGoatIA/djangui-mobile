import 'package:equatable/equatable.dart';
import 'package:kauri/features/payments/data/models/payment_model.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final PaymentInitResponseModel response;

  const PaymentSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class PaymentVerified extends PaymentState {
  final Map<String, dynamic> data;

  const PaymentVerified(this.data);

  @override
  List<Object?> get props => [data];
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError(this.message);

  @override
  List<Object?> get props => [message];
}
