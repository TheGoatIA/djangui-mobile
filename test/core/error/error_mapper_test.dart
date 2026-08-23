import 'package:flutter_test/flutter_test.dart';
import 'package:kauri/core/error/error_mapper.dart';

void main() {
  group('ErrorMapper Tests', () {
    test('cleans and formats KYC error without any NodeJS stack trace', () {
      const nodeTrace = '''
Error: KYC verification required before processing payout
    at WalletService.withdraw (/app/src/services/wallet.service.ts:145:13)
    at processTicksAndRejections (node:internal/process/task_queues:95:5)
''';
      final message = ErrorMapper.safeMessage(nodeTrace);
      expect(
        message,
        'Votre profil KYC n\'a pas encore été validé. Veuillez soumettre ou finaliser vos documents pour débloquer les retraits.',
      );
      expect(message.contains('at WalletService'), isFalse);
      expect(message.contains('node:internal'), isFalse);
    });

    test('extracts clean message from JSON stringified response', () {
      const jsonError = '{"status":"error","message":"Solde insuffisant pour ce montant","stack":"Error: ..."}';
      final message = ErrorMapper.safeMessage(jsonError);
      expect(message, 'Votre solde est insuffisant pour effectuer cette opération.');
    });

    test('cleans technical prefix and preserves clear French business message', () {
      const exception = 'BadRequestException: Le compte destinataire n\'est pas actif';
      final message = ErrorMapper.safeMessage(exception);
      expect(message, 'Le compte destinataire n\'est pas actif');
    });

    test('returns friendly message for 500 internal server error', () {
      const serverCrash = 'TypeError: Cannot read properties of undefined (reading \'id\')\n    at Object.run (/app/dist/index.js:12:34)';
      final message = ErrorMapper.safeMessage(serverCrash, statusCode: 500);
      expect(
        message,
        'Une erreur technique temporaire est survenue sur nos serveurs. Veuillez réessayer dans un instant.',
      );
    });
  });
}
