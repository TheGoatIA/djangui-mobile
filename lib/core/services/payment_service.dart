import 'package:injectable/injectable.dart';
import 'package:kauri/features/subscription/data/datasources/payment_api_service.dart';
import 'package:kauri/features/subscription/data/models/payment_model.dart';

@lazySingleton
class PaymentService {
  final PaymentApiService _apiService;

  PaymentService(this._apiService);

  Future<List<PaymentModel>> getPaymentHistory() async {
    try {
      final response = await _apiService.getPaymentHistory();
      if (response.isSuccessful && response.body != null) {
        final data = response.body!['data'] as List?;
        if (data != null) {
          return data
              .map((e) => PaymentModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  ({double amount, String currency, String formattedPrice})
  getSubscriptionPrice(String? countryCode) {
    switch (countryCode) {
      case 'FR':
      case 'BE':
      case 'DE':
      case 'IT':
      case 'ES':
        return (amount: 5.0, currency: 'EUR', formattedPrice: '5 € / mois');
      case 'US':
      case 'CA':
      case 'GB':
        return (amount: 6.0, currency: 'USD', formattedPrice: '6 \$ / month');
      case 'CM':
      default:
        return (
          amount: 2000.0,
          currency: 'XAF',
          formattedPrice: '2000 FCFA / mois',
        );
    }
  }

  Future<String?> initializeNotchPay(double amount, {String? currency}) async {
    final response = await _apiService.initializeNotchPay({
      'amount': amount,
      'currency': currency ?? 'XAF',
      'type': 'subscription',
    });

    if (response.isSuccessful && response.body != null) {
      final data = response.body!['data'] as Map<String, dynamic>?;
      return data?['url'] as String?;
    }
    return null;
  }

  Future<String?> createStripeCheckout(double amount, String currency) async {
    final response = await _apiService.createStripeCheckout({
      'amount': amount,
      'currency': currency,
      'type': 'subscription',
    });

    if (response.isSuccessful && response.body != null) {
      final data = response.body!['data'] as Map<String, dynamic>?;
      return data?['url'] as String?;
    }
    return null;
  }

  Future<bool> verifyTransaction(String reference) async {
    try {
      final response = await _apiService.verifyTransaction(reference);
      return response.isSuccessful;
    } catch (e) {
      return false;
    }
  }

  Future<bool> cancelSubscription() async {
    try {
      final response = await _apiService.cancelSubscription();
      return response.isSuccessful;
    } catch (e) {
      return false;
    }
  }
}
