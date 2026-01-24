import 'package:intl/intl.dart';

/// Utilitaire pour le formatage des montants monétaires.
class CurrencyHelper {
  /// Formate un montant numérique en une chaîne de caractères lisible avec sa devise.
  ///
  /// Gère spécifiquement les particularités des monnaies africaines (XAF, XOF)
  /// en utilisant des formats décimaux adaptés.
  static String formatAmount(
    double amount, {
    String? currencyCode,
    String? currencySymbol,
    String locale = 'fr',
  }) {
    final code = currencyCode ?? 'XAF';
    final symbol = currencySymbol ?? code;

    // Traitement spécifique pour le Franc CFA (Afrique Centrale et de l'Ouest)
    if (code == 'XAF' || code == 'XOF') {
      final formatter = NumberFormat.decimalPattern(locale);
      return '${formatter.format(amount)} ${symbol == code ? (code == 'XAF' ? 'FCFA' : 'F') : symbol}';
    }

    // Formatage standard via la bibliothèque intl pour les autres devises (EUR, USD, etc.)
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
}
