import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../di/injection.dart';
import '../bloc/goals_bloc.dart';
import '../bloc/goals_event.dart';
import '../bloc/goals_state.dart';

import '../../../../core/services/share_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../system/presentation/bloc/system_bloc.dart';
import '../../../../core/widgets/feature_disabled_widget.dart';

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

    return BlocBuilder<SystemBloc, SystemState>(
      builder: (context, systemState) {
        final featureStatus = context.read<SystemBloc>().getFeatureStatus(
          systemState.featureFlags.featGoals,
        );

        if (featureStatus == FeatureStatus.disabled) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.importGoal),
            ),
            body: FeatureDisabledWidget(
              title: AppLocalizations.of(context)!.goals,
            ),
          );
        }

        if (featureStatus == FeatureStatus.updateRequired) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.importGoal),
            ),
            body: FeatureDisabledWidget(
              title: AppLocalizations.of(context)!.goals,
              isUpdateRequired: true,
            ),
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
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.goalImportedSuccess,
                    ),
                  ),
                );
                context.go(RouteConstants.goals);
              }
            },
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(AppLocalizations.of(context)!.importGoal),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.sharedGoal,
                              style: AppTextStyles.labelLarge.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(goal.name, style: AppTextStyles.h2),
                            const SizedBox(height: 16),
                            _buildRow(
                              context,
                              AppLocalizations.of(context)!.targetAmount,
                              '${goal.targetAmount.toStringAsFixed(0)} F',
                            ),
                            _buildRow(
                              context,
                              AppLocalizations.of(context)!.deadline,
                              _formatDate(goal.deadline),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        AppLocalizations.of(context)!.addGoalToListPrompt,
                        style: AppTextStyles.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        text: AppLocalizations.of(context)!.acceptGoal,
                        isLoading: state.status == GoalsStatus.loading,
                        onPressed: () {
                          context.read<GoalsBloc>().add(AddGoalRequested(goal));
                        },
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => context.go(RouteConstants.dashboard),
                        child: Text(AppLocalizations.of(context)!.cancel),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
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
