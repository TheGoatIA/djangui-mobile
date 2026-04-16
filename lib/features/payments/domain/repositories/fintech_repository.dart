import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/fintech_models.dart';

abstract class FintechRepository {
  Future<Either<Failure, double>> getWalletBalance();
  Future<Either<Failure, List<FintechTransactionModel>>>
  getWalletTransactions();
  Future<Either<Failure, String>> requestPayout({
    required double amount,
    required String phoneNumber,
    required String provider,
  });
  Future<Either<Failure, String>> getInvoicePdfUrl(String transactionId);
  Future<Either<Failure, String>> getPaymentInvoicePdfUrl(String paymentId);
}
