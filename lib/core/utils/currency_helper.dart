import 'package:intl/intl.dart';

class CurrencyHelper {
  /// Maps ISO country codes to ISO currency codes
  /// Formats an amount with the specified currency code and symbol
  static String formatAmount(
    double amount, {
    String? currencyCode,
    String? currencySymbol,
    String locale = 'fr',
  }) {
    final code = currencyCode ?? 'XAF';
    final symbol = currencySymbol ?? code;

    // For common West African currencies not always handled perfectly by all intl versions
    if (code == 'XAF' || code == 'XOF') {
      final formatter = NumberFormat.decimalPattern(locale);
      return '${formatter.format(amount)} ${symbol == code ? (code == 'XAF' ? 'FCFA' : 'F') : symbol}';
    }

    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
}
