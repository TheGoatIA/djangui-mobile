import 'package:injectable/injectable.dart';
import 'package:djangui/features/subscription/data/datasources/payment_api_service.dart';

@lazySingleton
class PaymentService {
  final PaymentApiService _apiService;

  PaymentService(this._apiService);

  Future<String?> initializeNotchPay(double amount) async {
    final response = await _apiService.initializeNotchPay({
      'amount': amount,
      'currency': 'XAF',
    });

    if (response.isSuccessful && response.body != null) {
      return response.body!['payment_url'] as String?;
    }
    return null;
  }

  Future<String?> createStripeCheckout() async {
    final response = await _apiService.createStripeCheckout({
      'plan': 'premium_monthly',
    });

    if (response.isSuccessful && response.body != null) {
      return response.body!['checkout_url'] as String?;
    }
    return null;
  }
}
