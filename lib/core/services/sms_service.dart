import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:djangui/features/insights/data/datasources/ai_api_service.dart';

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
  final AiApiService _apiService;

  SMSService(this._apiService);

  Future<bool> requestPermission() async {
    final status = await Permission.sms.request();
    return status.isGranted;
  }

  Future<List<SMSTransaction>> getRecentTransactions() async {
    // In a real app, use flutter_sms_inbox to query messages
    // Here we simulate fetching messages and sending them to backend for parsing

    // Simulate raw SMS list (e.g. from MobileMoney, Orange Money)
    final rawSmsList = [
      "MobileMoney: Vous avez recu 25000 FCFA de Boris Gauty le 03/01/2026.",
      "Orange Money: Paiement de 5000 FCFA pour Canal+ effectue le 02/01/2026.",
    ];

    final response = await _apiService.parseSms({'messages': rawSmsList});

    if (response.isSuccessful && response.body != null) {
      return response.body!
          .map(
            (t) => SMSTransaction(
              amount: (t['amount'] as num).toDouble(),
              description: t['description'] as String,
              date: DateTime.parse(t['date'] as String),
              sender: t['sender'] as String,
            ),
          )
          .toList();
    }
    return [];
  }
}
