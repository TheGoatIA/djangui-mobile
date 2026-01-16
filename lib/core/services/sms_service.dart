/*
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

class SMSTransaction {
  final double amount;
  final String description;
  final DateTime date;
  final String sender;
  final String type; // 'income' or 'expense'

  SMSTransaction({
    required this.amount,
    required this.description,
    required this.date,
    required this.sender,
    required this.type,
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

  Future<List<String>> getRawMessagesLast24Hours() async {
    if (!await requestPermission()) return [];

    final now = DateTime.now();
    final last24h = now.subtract(const Duration(hours: 24));

    // We fetch a larger batch and filter by date
    final messages = await _query.querySms(
      kinds: [SmsQueryKind.inbox],
      count: 200, // Increased to ensure we cover busy days
    );

    return messages
        .where(
          (msg) =>
              msg.date != null &&
              msg.date!.isAfter(last24h) &&
              msg.body != null &&
              _isFinancialMessage(msg.address ?? '', msg.body!),
        )
        .map((msg) => msg.body!)
        .toList();
  }

  bool _isFinancialMessage(String sender, String body) {
    final lowerBody = body.toLowerCase();
    final address = sender.toLowerCase();

    // Known financial senders or keywords
    return address.contains('mobilemoney') ||
        address.contains('momo') ||
        address.contains('orangemoney') ||
        address.contains('om') ||
        lowerBody.contains('fcfa') ||
        lowerBody.contains('xaf') ||
        lowerBody.contains('transfert') ||
        lowerBody.contains('paiement') ||
        lowerBody.contains('dépôt') || // With accent
        lowerBody.contains('depot') ||
        lowerBody.contains('reçu') || // With accent
        lowerBody.contains('recu') ||
        lowerBody.contains('crédité') || // With accent
        lowerBody.contains('credite');
  }

  SMSTransaction? _parseMessage(String sender, String body, DateTime date) {
    final lowerBody = body.toLowerCase();

    if (sender.contains('MobileMoney') ||
        sender.contains('OrangeMoney') ||
        lowerBody.contains('fcfa') ||
        lowerBody.contains('xaf')) {
      final amount = _extractAmount(body);
      if (amount != null) {
        String type = 'expense';
        // Keywords for income
        if (lowerBody.contains('recu') ||
            lowerBody.contains('received') ||
            lowerBody.contains('depot') ||
            lowerBody.contains('credité') ||
            lowerBody.contains('credit')) {
          type = 'income';
        }

        return SMSTransaction(
          amount: amount,
          description: _cleanBody(body),
          date: date,
          sender: sender,
          type: type,
        );
      }
    }
    return null;
  }

  String _cleanBody(String body) {
    // Try to extract a clean description or just return the body if too complex
    // For now, let's keep it simple: take first 50 chars or similar
    if (body.length > 60) {
      return '${body.substring(0, 57)}...';
    }
    return body;
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
*/
