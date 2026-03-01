import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import 'package:kauri/features/payments/data/models/payment_model.dart';

abstract class PaymentRepository {
  Future<Either<Failure, PaymentInitResponseModel>> initStripeCheckout({
    required double amount,
    required String currency,
  });

  Future<Either<Failure, PaymentInitResponseModel>> initNotchPayPayment({
    required double amount,
    required String phone,
    String type = 'deposit',
  });

  Future<Either<Failure, Map<String, dynamic>>> verifyPayment(String reference);
}
