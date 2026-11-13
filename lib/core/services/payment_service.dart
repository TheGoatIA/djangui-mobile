import 'package:injectable/injectable.dart';
import 'package:kauri/core/utils/app_l10n.dart';
import 'package:kauri/core/analytics/events.dart';
import 'package:kauri/features/subscription/data/datasources/payment_api_service.dart';
import 'package:kauri/features/subscription/data/models/payment_model.dart';
import 'package:kauri/core/services/telemetry_service.dart';
import 'package:kauri/di/injection.dart';
import 'package:kauri/core/services/log_service.dart';

import 'package:kauri/features/subscription/data/models/plan_config_model.dart';

/// Service gérant les opérations de paiement et d'abonnement.
///
/// Interagit avec l'API pour récupérer l'historique, initialiser des paiements
/// via plusieurs fournisseurs (NotchPay, Stripe) et gérer les tarifs selon le pays.
@lazySingleton
class PaymentService {
  final PaymentApiService _apiService;
  TelemetryService get _telemetry => getIt<TelemetryService>();

  PaymentService(this._apiService);

  /// Récupère la liste dynamique des forfaits configurés depuis l'API backend.
  Future<List<PlanConfigModel>> getPlansConfig({String language = 'fr'}) async {
    try {
      final response = await _apiService.getPlansConfig();
      if (response.isSuccessful && response.body != null) {
        final data = response.body!['data'] as List?;
        if (data != null && data.isNotEmpty) {
          return data
              .map(
                (e) => PlanConfigModel.fromJson(
                  e as Map<String, dynamic>,
                  language: language,
                ),
              )
              .toList();
        }
      }
      return [];
    } catch (e) {
      getIt<LogService>().error(
        'Erreur récupération forfaits dynamiques',
        component: 'PaymentService',
        error: e,
      );
      return [];
    }
  }

  /// Récupère l'historique des paiements effectués par l'utilisateur.
  Future<List<PaymentModel>> getPaymentHistory({
    String type = 'subscription',
  }) async {
    try {
      final response = await _apiService.getPaymentHistory(type: type);
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
      getIt<LogService>().error(
        'Erreur récupération historique paiements',
        component: 'PaymentService',
        error: e,
      );
      return [];
    }
  }

  /// Retourne les détails du tarif de l'abonnement en fonction du code pays (ISO).
  /// Permet l'affichage dynamique des prix en FCFA, EUR ou USD.
  ({double amount, String currency, String formattedPrice})
  getSubscriptionPrice(String? countryCode) {
    switch (countryCode) {
      case 'FR':
      case 'BE':
      case 'DE':
      case 'IT':
      case 'ES':
        return (
          amount: 5.0,
          currency: 'EUR',
          formattedPrice: '5 € ${appL10n().perMonthSuffix}',
        );
      case 'US':
      case 'CA':
      case 'GB':
        return (
          amount: 6.0,
          currency: 'USD',
          formattedPrice: '6 \$ ${appL10n().perMonthSuffix}',
        );
      case 'CM':
      default:
        return (
          amount: 2000.0,
          currency: 'XAF',
          formattedPrice: '2000 FCFA ${appL10n().perMonthSuffix}',
        );
    }
  }

  /// Retourne les détails du tarif Super Premium (Business / Hub Revendeur).
  ({double amount, String currency, String formattedPrice})
  getBusinessSubscriptionPrice(String? countryCode) {
    switch (countryCode) {
      case 'FR':
      case 'BE':
      case 'DE':
      case 'IT':
      case 'ES':
        return (
          amount: 12.0,
          currency: 'EUR',
          formattedPrice: '12 € ${appL10n().perMonthSuffix}',
        );
      case 'US':
      case 'CA':
      case 'GB':
        return (
          amount: 15.0,
          currency: 'USD',
          formattedPrice: '15 \$ ${appL10n().perMonthSuffix}',
        );
      case 'CM':
      default:
        return (
          amount: 5000.0,
          currency: 'XAF',
          formattedPrice: '5000 FCFA ${appL10n().perMonthSuffix}',
        );
    }
  }

  /// Initialise une transaction via NotchPay (préféré pour l'Afrique de l'Ouest/Centrale).
  /// Retourne l'URL de paiement vers laquelle rediriger l'utilisateur ainsi que
  /// la référence interne, indispensable pour vérifier le paiement au retour.
  Future<({String url, String reference})?> initializeNotchPay(
    double amount, {
    String? currency,
    String? phone,
    String? plan,
  }) async {
    final body = <String, dynamic>{
      'amount': amount,
      'currency': currency ?? 'XAF',
      'type': 'subscription',
    };
    if (phone != null && phone.trim().isNotEmpty) {
      body['phone'] = phone.trim();
    }
    if (plan != null && plan.trim().isNotEmpty) {
      body['plan'] = plan.trim();
    }

    final response = await _apiService.initializeNotchPay(body);

    if (response.isSuccessful && response.body != null) {
      final data = response.body!['data'] as Map<String, dynamic>?;
      final url = data?['url'] as String?;
      final reference = data?['reference'] as String?;

      // Telemetry: Payment Initialized
      _telemetry.recordEvent('business.payment.init', {
        'provider': 'notchpay',
        'amount_range': AnalyticsAmountRange.fromAmount(amount),
        'currency': currency ?? 'XAF',
        'plan': plan ?? 'premium',
        'success': url != null,
      });

      if (url == null) return null;
      return (url: url, reference: reference ?? '');
    }
    getIt<LogService>().warning(
      'Échec initialisation NotchPay',
      component: 'PaymentService',
      metadata: {
        'amount_range': AnalyticsAmountRange.fromAmount(amount),
        'response': response.body,
      },
    );
    return null;
  }

  /// Initialise une transaction via Stripe Checkout.
  /// Retourne l'URL de paiement générée par Stripe et la référence interne.
  Future<({String url, String reference})?> createStripeCheckout(
    double amount,
    String currency, {
    String? plan,
  }) async {
    final body = <String, dynamic>{
      'amount': amount,
      'currency': currency,
      'type': 'subscription',
    };
    if (plan != null && plan.trim().isNotEmpty) {
      body['plan'] = plan.trim();
    }

    final response = await _apiService.createStripeCheckout(body);

    if (response.isSuccessful && response.body != null) {
      final data = response.body!['data'] as Map<String, dynamic>?;
      final url = data?['url'] as String?;
      final reference = data?['reference'] as String?;

      // Telemetry: Payment Initialized
      _telemetry.recordEvent('business.payment.init', {
        'provider': 'stripe',
        'amount_range': AnalyticsAmountRange.fromAmount(amount),
        'currency': currency,
        'plan': plan ?? 'premium',
        'success': url != null,
      });

      if (url == null) return null;
      return (url: url, reference: reference ?? '');
    }
    getIt<LogService>().warning(
      'Échec initialisation Stripe',
      component: 'PaymentService',
      metadata: {'amount': amount, 'response': response.body},
    );
    return null;
  }

  /// Vérifie le statut final d'une transaction à partir de sa référence.
  ///
  /// L'API répond HTTP 200 même quand le paiement est encore en attente
  /// (`data.status` = 'pending'), donc `response.isSuccessful` ne prouve rien :
  /// seul `data.status == 'completed'` signifie que l'abonnement est activé.
  Future<bool> verifyTransaction(String reference) async {
    try {
      final response = await _apiService.verifyTransaction(reference);
      final data = response.body?['data'];
      final status = data is Map ? data['status'] as String? : null;
      final success = response.isSuccessful && status == 'completed';

      // Telemetry: Payment Verification
      _telemetry.recordEvent('business.payment.verify', {
        'reference': reference,
        'status': status ?? 'unknown',
        'success': success,
      });

      return success;
    } catch (e) {
      getIt<LogService>().error(
        'Erreur vérification transaction',
        component: 'PaymentService',
        error: e,
        metadata: {'reference': reference},
      );
      return false;
    }
  }

  /// Demande l'annulation de l'abonnement Premium en cours.
  Future<bool> cancelSubscription() async {
    try {
      final response = await _apiService.cancelSubscription();
      return response.isSuccessful;
    } catch (e) {
      getIt<LogService>().error(
        'Erreur annulation abonnement',
        component: 'PaymentService',
        error: e,
      );
      return false;
    }
  }

  /// Paye l'abonnement Premium directement depuis le portefeuille Kauri.
  Future<({bool success, String message})> paySubscriptionWithWallet({
    String? plan,
  }) async {
    try {
      final response = await _apiService.paySubscriptionWithWallet(
        body: plan != null ? {'plan': plan} : null,
      );
      if (response.isSuccessful && response.body != null) {
        final message =
            response.body!['data']?['message'] as String? ??
            response.body!['message'] as String? ??
            'Abonnement activé avec succès';

        _telemetry.recordEvent('business.payment.wallet_subscription', {
          'provider': 'wallet',
          'plan': plan ?? 'premium',
          'success': true,
        });

        return (success: true, message: message);
      }

      final errorMsg =
          response.body?['message'] as String? ??
          response.error?.toString() ??
          'Échec du paiement avec le portefeuille';
      return (success: false, message: errorMsg);
    } catch (e) {
      getIt<LogService>().error(
        'Erreur paiement abonnement via portefeuille',
        component: 'PaymentService',
        error: e,
      );
      return (success: false, message: e.toString());
    }
  }
}
