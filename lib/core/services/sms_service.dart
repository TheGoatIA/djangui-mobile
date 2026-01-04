import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

class SMSTransaction {
  final double amount;
  final String description;
  final DateTime date;
  final String sender;

  SMSTransaction({
    required this.amount,
    required this.description,
    required this.date,
    required this.sender,
  });
}

@lazySingleton
class SMSService {
  final SmsQuery _query = SmsQuery();

  Future<bool> requestPermission() async {
    final status = await Permission.sms.request();
    return status.isGranted;
  }

  Future<List<SMSTransaction>> getRecentTransactions() async {
    if (!await requestPermission()) return [];

    final messages = await _query.querySms(
      kinds: [SmsQueryKind.inbox],
      count: 20, // Limit to recent
    );

    final transactions = <SMSTransaction>[];

    for (final msg in messages) {
      final body = msg.body;
      final sender = msg.address;
      final date = msg.date;

      if (body == null || sender == null || date == null) continue;

      final transaction = _parseMessage(sender, body, date);
      if (transaction != null) {
        transactions.add(transaction);
      }
    }

    return transactions;
  }

  SMSTransaction? _parseMessage(String sender, String body, DateTime date) {
    // Basic Parsing Logic for common providers in Cameroon/Africa
    // Adjust based on real SMS formats.

    // Example: "MobileMoney: Vous avez recu 25000 FCFA de Boris..."
    // Example: "Orange Money: Paiement de 5000 FCFA..."

    if (sender.contains('MobileMoney') ||
        sender.contains('OrangeMoney') ||
        body.contains('FCFA')) {
      final amount = _extractAmount(body);
      if (amount != null) {
        return SMSTransaction(
          amount: amount,
          description: body, // Or extract cleaner description
          date: date,
          sender: sender,
        );
      }
    }
    return null;
  }

  double? _extractAmount(String text) {
    // Regex to find amounts like 25000 FCFA, 5.000 F
    final RegExp amountRegex = RegExp(r'(\d+[.,]?\d*)\s*(FCFA|F|XAF)');
    final match = amountRegex.firstMatch(text);
    if (match != null) {
      String clean = match.group(1)!.replaceAll(',', '').replaceAll('.', '');
      // Note: Be careful with decimals. usually FCFA has no decimal or it's a comma.
      // E.g. 5,000 matches digits: 5,000. Clean -> 5000.
      // E.g. 10.5 USD. Regex here catches "FCFA".
      return double.tryParse(clean);
    }
    return null;
  }
}
