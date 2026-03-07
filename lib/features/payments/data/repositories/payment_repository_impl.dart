import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import 'package:kauri/features/payments/domain/repositories/payment_repository.dart';
import 'package:kauri/features/payments/data/models/payment_model.dart';
import 'package:kauri/features/payments/data/datasources/payments_api_service.dart';

@LazySingleton(as: PaymentRepository)
class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentsApiService _apiService;
  final NetworkInfo _networkInfo;

  PaymentRepositoryImpl(this._apiService, this._networkInfo);

  @override
  Future<Either<Failure, PaymentInitResponseModel>> initStripeCheckout({
    required double amount,
    required String currency,
  }) async {
    if (!await _networkInfo.isConnected) return Left(NetworkFailure());

    try {
      final response = await _apiService.initStripeCheckout({
        'amount': amount,
        'currency': currency,
      });
      if (response.isSuccessful && response.body?.data != null) {
        return Right(response.body!.data!);
      }
      return Left(ServerFailure(response.error?.toString() ?? 'Erreur Stripe'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaymentInitResponseModel>> initNotchPayPayment({
    required double amount,
    required String phone,
    String type = 'deposit',
  }) async {
    if (!await _networkInfo.isConnected) return Left(NetworkFailure());

    try {
      final response = await _apiService.initNotchPayPayment({
        'amount': amount,
        'phone': phone,
        'type': type,
      });
      if (response.isSuccessful && response.body?.data != null) {
        return Right(response.body!.data!);
      }
      return Left(
        ServerFailure(response.error?.toString() ?? 'Erreur NotchPay'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> verifyPayment(
    String reference,
  ) async {
    if (!await _networkInfo.isConnected) return Left(NetworkFailure());

    try {
      final response = await _apiService.verifyPayment(reference);
      if (response.isSuccessful && response.body?.data != null) {
        return Right(response.body!.data!);
      }
      return Left(
        ServerFailure(response.error?.toString() ?? 'Erreur Vérification'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
