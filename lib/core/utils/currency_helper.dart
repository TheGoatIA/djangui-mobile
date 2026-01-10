import 'package:intl/intl.dart';

class CurrencyHelper {
  /// Maps ISO country codes to ISO currency codes
  static const Map<String, String> countryToCurrency = {
    'CM': 'XAF', // Cameroon
    'FR': 'EUR', // France
    'US': 'USD', // USA
    'GA': 'XAF', // Gabon
    'CI': 'XOF', // Ivory Coast
    'SN': 'XOF', // Senegal
    'BE': 'EUR', // Belgium
    'CA': 'CAD', // Canada
    'GB': 'GBP', //UK
    // Add more as needed
  };

  /// Gets the currency code based on country code
  static String getCurrencyCode(String countryCode) {
    return countryToCurrency[countryCode.toUpperCase()] ?? 'USD';
  }

  /// Formats an amount with the specified currency code
  static String formatAmount(
    double amount, {
    String? currencyCode,
    String locale = 'fr',
  }) {
    final code = currencyCode ?? 'XAF';

    // For common West African currencies not always handled perfectly by all intl versions
    if (code == 'XAF' || code == 'XOF') {
      final formatter = NumberFormat.decimalPattern(locale);
      return '${formatter.format(amount)} ${code == 'XAF' ? 'FCFA' : 'F'}';
    }

    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: _getSymbol(code),
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String _getSymbol(String code) {
    switch (code) {
      case 'EUR':
        return '€';
      case 'USD':
        return '\$';
      case 'GBP':
        return '£';
      case 'CAD':
        return 'C\$';
      default:
        return code;
    }
  }
}
