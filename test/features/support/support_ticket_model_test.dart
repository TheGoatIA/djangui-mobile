import 'package:flutter_test/flutter_test.dart';
import 'package:kauri/features/support/data/models/support_ticket_model.dart';

void main() {
  test(
    'ticket avec réponses telles que l\'API les renvoie (`date`, pas `createdAt`) → lisible',
    () {
      final t = SupportTicketModel.fromJson({
        '_id': 't1',
        'subject': 'Recharge non reçue',
        'message': 'Mon solde n\'a pas bougé',
        'category': 'payment',
        'status': 'in_progress',
        'createdAt': '2026-11-11T21:00:00.000Z',
        'updatedAt': '2026-11-11T21:05:00.000Z',
        'responses': [
          {
            'sender': 'admin',
            'message': 'Nous vérifions.',
            'date': '2026-11-11T21:03:00.000Z',
          },
          {
            'sender': 'user',
            'message': 'Merci',
            'date': '2026-11-11T21:04:00.000Z',
          },
        ],
      });
      expect(t.replies, hasLength(2));
      expect(t.replies!.first.isAdmin, isTrue);
      expect(t.replies!.first.message, 'Nous vérifions.');
      expect(
        t.replies!.first.createdAt.toUtc(),
        DateTime.utc(2026, 11, 11, 21, 3),
      );
    },
  );
}
