import 'dart:convert';

/// Refus du serveur à l'initialisation d'un paiement (NotchPay / Stripe),
/// avec son message lisible (ex. « Les paiements réels sont actuellement
/// désactivés »). Avant, ce message était perdu et l'app affichait une erreur
/// générique (« Initialisation paiement échouée »).
class PaymentInitException implements Exception {
  const PaymentInitException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Extrait le message lisible d'une réponse d'erreur du serveur
/// (`{"message": "…"}`, en objet ou en texte JSON). Null si absent.
String? serverErrorMessage(Object? error) {
  Object? data = error;
  if (data is String) {
    try {
      data = jsonDecode(data);
    } on FormatException {
      return null;
    }
  }
  if (data is Map && data['message'] is String) {
    final message = (data['message'] as String).trim();
    return message.isEmpty ? null : message;
  }
  return null;
}
