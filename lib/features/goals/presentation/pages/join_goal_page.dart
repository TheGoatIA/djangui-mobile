import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/services/log_service.dart';
import '../../../../di/injection.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';
import '../bloc/goals_bloc.dart';
import '../bloc/goals_event.dart';
import '../bloc/goals_state.dart';

/// Rejoindre un objectif partagé par code d'invitation — calqué sur
/// JoinBudgetPage, même logique : pas de nom d'affichage à saisir, le
/// backend le déduit du profil connecté (GoalController.join).
class JoinGoalPage extends StatefulWidget {
  const JoinGoalPage({super.key});

  @override
  State<JoinGoalPage> createState() => _JoinGoalPageState();
}

class _JoinGoalPageState extends State<JoinGoalPage> {
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<LogService>().info(
        'Affichage page rejoindre objectif',
        component: 'JoinGoalPage',
      );
      final code = GoRouterState.of(context).uri.queryParameters['code'];
      if (code != null) _codeController.text = code;
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<GoalsBloc, GoalsState>(
      listener: (context, state) {
        if (state.status == GoalsStatus.joinSuccess) {
          getIt<AnalyticsManager>().trackEvent(
            feature: 'Goals',
            action: 'join_success',
          );
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.successJoinGoal)));
          context.pop(true);
        } else if (state.status == GoalsStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? l10n.genericError)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.joinGoal)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.enterInviteCode, style: AppTextStyles.h2),
              const SizedBox(height: 8),
              Text(
                l10n.joinGoalDescription,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: l10n.inviteCode,
                  prefixIcon: const Icon(Icons.qr_code),
                ),
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 32),
              BlocBuilder<GoalsBloc, GoalsState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state.status == GoalsStatus.loading
                        ? null
                        : () {
                            final code = _codeController.text.trim();
                            if (code.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.requiredField)),
                              );
                              return;
                            }
                            getIt<LogService>().info(
                              'Action: Tentative de rejoindre objectif $code',
                              component: 'JoinGoalPage',
                            );
                            context.read<GoalsBloc>().add(
                              JoinGoalRequested(code),
                            );
                          },
                    child: state.status == GoalsStatus.loading
                        ? const CircularProgressIndicator()
                        : Text(l10n.joinNow),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
