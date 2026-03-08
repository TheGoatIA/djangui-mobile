import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/fintech_api_service.dart';
import '../models/fintech_models.dart';
import 'package:kauri/features/payments/domain/repositories/fintech_repository.dart';

@LazySingleton(as: FintechRepository)
class FintechRepositoryImpl implements FintechRepository {
  final FintechApiService _apiService;
  final NetworkInfo _networkInfo;

  FintechRepositoryImpl(this._apiService, this._networkInfo);

  @override
  Future<Either<Failure, double>> getWalletBalance() async {
    if (!await _networkInfo.isConnected) return Left(NetworkFailure());

    try {
      final response = await _apiService.getBalance();
      if (response.isSuccessful && response.body?.data != null) {
        final balance = response.body!.data!['balance'] as num;
        return Right(balance.toDouble());
      }
      return Left(
        ServerFailure(response.error?.toString() ?? 'Erreur inconnue'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FintechTransactionModel>>>
  getWalletTransactions() async {
    if (!await _networkInfo.isConnected) return Left(NetworkFailure());

    try {
      final response = await _apiService.getTransactions();
      if (response.isSuccessful && response.body?.data != null) {
        return Right(response.body!.data!.transactions);
      }
      return Left(
        ServerFailure(response.error?.toString() ?? 'Erreur inconnue'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> requestPayout({
    required double amount,
    required String phoneNumber,
    required String provider,
  }) async {
    if (!await _networkInfo.isConnected) return Left(NetworkFailure());

    try {
      // Mapping operator to provider expected by API
      final mappedProvider = provider == 'CM_MOMO' ? 'mtn' : 'orange';

      // Formatting phone number to include +237 if missing
      String formattedPhone = phoneNumber
          .replaceAll(' ', '')
          .replaceAll('-', '');
      if (!formattedPhone.startsWith('+')) {
        if (formattedPhone.startsWith('237')) {
          formattedPhone = '+$formattedPhone';
        } else {
          formattedPhone = '+237$formattedPhone';
        }
      }

      final response = await _apiService.withdraw({
        'amount': amount,
        'phoneNumber': formattedPhone,
        'provider': mappedProvider,
      });
      if (response.isSuccessful && response.body?.data != null) {
        return Right(
          response.body!.data!['message'] ?? 'Demande de retrait envoyée',
        );
      }
      return Left(
        ServerFailure(response.error?.toString() ?? 'Erreur inconnue'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getInvoicePdfUrl(String transactionId) async {
    if (!await _networkInfo.isConnected) return Left(NetworkFailure());

    try {
      final response = await _apiService.getInvoice(transactionId);
      if (response.isSuccessful && response.body?.data != null) {
        final pdfUrl = response.body!.data!.pdfUrl;
        String finalPdfUrl = pdfUrl;
        final baseUrlStr = dotenv.env['API_BASE_URL'];
        if (baseUrlStr != null &&
            (finalPdfUrl.contains('localhost') ||
                finalPdfUrl.contains('127.0.0.1'))) {
          final uri = Uri.parse(baseUrlStr);
          finalPdfUrl = finalPdfUrl
              .replaceAll('localhost', uri.host)
              .replaceAll('127.0.0.1', uri.host);
        }
        return Right(finalPdfUrl);
      }
      return Left(
        ServerFailure(response.error?.toString() ?? 'Erreur inconnue'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
