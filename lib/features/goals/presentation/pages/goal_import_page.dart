import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../di/injection.dart';
import '../bloc/goals_bloc.dart';
import '../bloc/goals_event.dart';
import '../bloc/goals_state.dart';

import '../../../../core/services/share_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/route_constants.dart';

class GoalImportPage extends StatelessWidget {
  final String dataToken;

  const GoalImportPage({super.key, required this.dataToken});

  @override
  Widget build(BuildContext context) {
    final shareService = getIt<ShareService>();
    final goal = shareService.parseGoalFromToken(dataToken);

    if (goal == null) {
      return Scaffold(
        body: Center(child: Text(AppLocalizations.of(context)!.genericError)),
      );
    }

    return BlocProvider(
      create: (context) =>
          getIt<
            GoalsBloc
          >(), // Use existing bloc or new instance? New instance fine for adding.
      child: BlocConsumer<GoalsBloc, GoalsState>(
        listener: (context, state) {
          if (state.status == GoalsStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Objectif importé avec succès !')),
            );
            context.go(RouteConstants.goals);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Importer un objectif')),
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🎉 Objectif Partagé',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(goal.name, style: AppTextStyles.h2),
                        const SizedBox(height: 16),
                        _buildRow(
                          'Montant cible',
                          '${goal.targetAmount.toStringAsFixed(0)} F',
                        ),
                        _buildRow('Date limite', _formatDate(goal.deadline)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Voulez-vous ajouter cet objectif à votre liste ?',
                    style: AppTextStyles.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'Accepter l\'objectif',
                    isLoading: state.status == GoalsStatus.loading,
                    onPressed: () {
                      context.read<GoalsBloc>().add(AddGoalRequested(goal));
                    },
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.go(RouteConstants.dashboard),
                    child: const Text('Annuler'),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[700]),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
