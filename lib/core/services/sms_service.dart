/*
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

/// Modèle représentant une transaction extraite d'un message SMS.
class SMSTransaction {
  final double amount;
  final String description;
  final DateTime date;
  final String sender;
  final String type; // 'income' (revenu) ou 'expense' (dépense)

  SMSTransaction({
    required this.amount,
    required this.description,
    required this.date,
    required this.sender,
    required this.type,
  });
}

/// Service chargé d'analyser les SMS reçus pour détecter des transactions financières.
/// 
/// Note : Ce service est actuellement en cours d'intégration (commenté).
@lazySingleton
class SMSService {
  final SmsQuery _query = SmsQuery();

  /// Demande l'autorisation d'accéder aux SMS sur l'appareil.
  Future<bool> requestPermission() async {
    final status = await Permission.sms.request();
    return status.isGranted;
  }

  /// Récupère et analyse les 20 derniers messages du dossier de réception.
  Future<List<SMSTransaction>> getRecentTransactions() async {
    if (!await requestPermission()) return [];

    final messages = await _query.querySms(
      kinds: [SmsQueryKind.inbox],
      count: 20,
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

  /// Récupère les messages bruts des dernières 24 heures pour analyse groupée via IA.
  Future<List<String>> getRawMessagesLast24Hours() async {
    if (!await requestPermission()) return [];

    final now = DateTime.now();
    final last24h = now.subtract(const Duration(hours: 24));

    final messages = await _query.querySms(
      kinds: [SmsQueryKind.inbox],
      count: 200, 
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

  /// Vérifie si un message provient d'un expéditeur financier connu ou contient des mots-clés bancaires.
  bool _isFinancialMessage(String sender, String body) {
    final lowerBody = body.toLowerCase();
    final address = sender.toLowerCase();

    return address.contains('mobilemoney') ||
        address.contains('momo') ||
        address.contains('orangemoney') ||
        address.contains('om') ||
        lowerBody.contains('fcfa') ||
        lowerBody.contains('xaf') ||
        lowerBody.contains('transfert') ||
        lowerBody.contains('paiement') ||
        lowerBody.contains('dépôt') ||
        lowerBody.contains('depot') ||
        lowerBody.contains('reçu') ||
        lowerBody.contains('recu') ||
        lowerBody.contains('crédité') ||
        lowerBody.contains('credite');
  }

  /// Analyse le contenu textuel d'un message pour extraire les données de transaction.
  SMSTransaction? _parseMessage(String sender, String body, DateTime date) {
    final lowerBody = body.toLowerCase();

    if (sender.contains('MobileMoney') ||
        sender.contains('OrangeMoney') ||
        lowerBody.contains('fcfa') ||
        lowerBody.contains('xaf')) {
      final amount = _extractAmount(body);
      if (amount != null) {
        String type = 'expense';
        // Identification du sens de la transaction (Revenu vs Dépense)
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

  /// Nettoie ou tronque le corps du message pour l'affichage.
  String _cleanBody(String body) {
    if (body.length > 60) {
      return '${body.substring(0, 57)}...';
    }
    return body;
  }

  /// Utilise une expression régulière pour extraire le montant numérique suivi d'une devise.
  double? _extractAmount(String text) {
    final RegExp amountRegex = RegExp(r'(\d+[.,]?\d*)\s*(FCFA|F|XAF)');
    final match = amountRegex.firstMatch(text);
    if (match != null) {
      String clean = match.group(1)!.replaceAll(',', '').replaceAll('.', '');
      return double.tryParse(clean);
    }
    return null;
  }
}
*/
