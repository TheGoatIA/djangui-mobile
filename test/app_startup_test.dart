import 'package:flutter_test/flutter_test.dart';
import 'package:kauri/core/utils/password_validator.dart';
import 'package:kauri/features/transactions/data/models/transaction_model.dart';
import 'package:kauri/core/error/error_mapper.dart';

void main() {
  group('App Security & Startup Rules Validation', () {
    test(
      'PasswordValidator enforces 8+ chars, uppercase, lowercase, digit, special char',
      () {
        // Too short
        expect(PasswordValidator.isValid('Ab1!'), isFalse);
        expect(PasswordValidator.isValid('Abcdef1!'), isTrue);

        // Missing uppercase
        expect(PasswordValidator.isValid('abcdef1!'), isFalse);

        // Missing lowercase
        expect(PasswordValidator.isValid('ABCDEF1!'), isFalse);

        // Missing digit
        expect(PasswordValidator.isValid('Abcdefgh!'), isFalse);

        // Missing special character
        expect(PasswordValidator.isValid('Abcdefg12'), isFalse);

        // Valid strong passwords
        expect(PasswordValidator.isValid('Kauri@2026'), isTrue);
        expect(PasswordValidator.isValid('P@ssw0rd123!'), isTrue);
        expect(PasswordValidator.isValid('Secur3#Pass'), isTrue);
      },
    );

    test(
      'TransactionModel.isMutable protects real-money transactions (F01)',
      () {
        final cashTx = TransactionModel(
          id: '1',
          amount: 5000,
          type: 'expense',
          category: 'Food',
          description: 'Lunch',
          date: DateTime.now(),
          paymentMethod: 'cash',
          source: 'manual',
        );

        final manualTx = TransactionModel(
          id: '2',
          amount: 2000,
          type: 'income',
          category: 'Gift',
          description: 'Cash gift',
          date: DateTime.now(),
          paymentMethod: null,
          source: 'manual',
        );

        final stripeTx = TransactionModel(
          id: '3',
          amount: 15000,
          type: 'expense',
          category: 'Subscription',
          description: 'Premium Stripe',
          date: DateTime.now(),
          paymentMethod: 'stripe',
          source: 'stripe',
        );

        final notchpayTx = TransactionModel(
          id: '4',
          amount: 10000,
          type: 'income',
          category: 'Deposit',
          description: 'NotchPay Mobile Money',
          date: DateTime.now(),
          paymentMethod: 'notchpay',
          source: 'notchpay',
        );

        final walletTx = TransactionModel(
          id: '5',
          amount: 50000,
          type: 'transfer',
          category: 'Transfer',
          description: 'Wallet transfer',
          date: DateTime.now(),
          paymentMethod: 'wallet',
          source: 'wallet',
        );

        // Only cash/manual are mutable
        expect(cashTx.isMutable, isTrue);
        expect(manualTx.isMutable, isTrue);

        // Real financial transactions are immutable
        expect(stripeTx.isMutable, isFalse);
        expect(notchpayTx.isMutable, isFalse);
        expect(walletTx.isMutable, isFalse);
      },
    );

    test('ErrorMapper sanitizes exceptions without leaking technical traces', () {
      const serverCrash =
          'TypeError: Cannot read properties of undefined (reading \'id\')\n    at Object.run (/app/dist/index.js:12:34)';
      final safe500 = ErrorMapper.safeMessage(serverCrash, statusCode: 500);
      expect(safe500.contains('index.js'), isFalse);
      expect(safe500.contains('TypeError'), isFalse);

      const kycTrace =
          'Error: KYC verification required before processing payout\n    at WalletService.withdraw (/app/src/services/wallet.service.ts:145:13)';
      final safeKyc = ErrorMapper.safeMessage(kycTrace);
      expect(safeKyc.contains('wallet.service.ts'), isFalse);
      expect(safeKyc.contains('WalletService.withdraw'), isFalse);
    });
  });
}
