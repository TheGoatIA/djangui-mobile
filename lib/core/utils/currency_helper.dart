import 'package:intl/intl.dart';

/// Utilitaire pour le formatage des montants monétaires.
class CurrencyHelper {
  /// Formate un montant numérique en une chaîne de caractères lisible avec sa devise.
  ///
  /// Gère spécifiquement les particularités des monnaies africaines (XAF, XOF, FCFA)
  /// en utilisant des formats décimaux adaptés (ex: 50 000 FCFA).
  static String formatAmount(
    double amount, {
    String? currencyCode,
    String? currencySymbol,
    String locale = 'fr',
    bool showDecimals = false,
  }) {
    final code = (currencyCode ?? 'XAF').toUpperCase();
    final symbol = currencySymbol ?? getSymbolForCode(code);

    // Traitement spécifique pour le Franc CFA (Afrique Centrale et de l'Ouest)
    if (code == 'XAF' || code == 'XOF' || code == 'FCFA') {
      final formatter = NumberFormat.decimalPattern(locale);
      return '${formatter.format(amount)} $symbol';
    }

    // Formatage standard via la bibliothèque intl pour les autres devises (EUR, USD, etc.)
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: showDecimals ? 2 : 0,
    );
    return formatter.format(amount);
  }

  /// Retourne le symbole d'affichage propre pour un code devise donné.
  static String getSymbolForCode(String? currencyCode) {
    if (currencyCode == null) return 'FCFA';
    final code = currencyCode.toUpperCase();
    switch (code) {
      case 'XAF':
      case 'XOF':
      case 'FCFA':
        return 'FCFA';
      case 'EUR':
        return '€';
      case 'USD':
        return '\$';
      case 'GBP':
        return '£';
      case 'CAD':
        return 'CA\$';
      default:
        return code;
    }
  }
}