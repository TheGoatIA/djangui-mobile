import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/services/log_service.dart';
import '../../../../di/injection.dart';

class PaymentFailurePage extends StatelessWidget {
  final String? ref;
  final String? message;

  const PaymentFailurePage({super.key, this.ref, this.message});

  @override
  Widget build(BuildContext context) {
    getIt<LogService>().warning(
      'Affichage page échec paiement (ref: $ref)',
      component: 'PaymentFailurePage',
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: Theme.of(context).colorScheme.error,
                size: 80,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Paiement Échoué',
              textAlign: TextAlign.center,
              style: AppTextStyles.h1,
            ),
            const SizedBox(height: 16),
            Text(
              message ??
                  'Nous n\'avons pas pu traiter votre paiement.\nVeuillez vérifier vos informations ou réessayer plus tard.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            if (ref != null) ...[
              const SizedBox(height: 24),
              Text(
                'Référence: $ref',
                style: AppTextStyles.bodySmall,
              ),
            ],
            const SizedBox(height: 48),
            AppButton(
              text: 'Réessayer le paiement',
              onPressed: () {
                context.go(RouteConstants.subscription);
              },
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                context.go(RouteConstants.dashboard);
              },
              child: Text(
                'Retour au Tableau de Bord',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
