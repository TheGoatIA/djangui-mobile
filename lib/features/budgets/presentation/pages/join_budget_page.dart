import 'package:flutter/material.dart';
import 'package:kauri/core/constants/route_constants.dart';
import 'package:kauri/core/navigation/safe_pop.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/services/log_service.dart';
import '../../../../di/injection.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';
import '../bloc/budgets_bloc.dart';
import '../bloc/budgets_event.dart';
import '../bloc/budgets_state.dart';

/// Rejoindre un budget partagé par code d'invitation — calqué sur
/// JoinTontinePage, mais plus simple : pas de nom d'affichage à saisir,
/// le backend le déduit du profil connecté (BudgetController.join).
class JoinBudgetPage extends StatefulWidget {
  const JoinBudgetPage({super.key});

  @override
  State<JoinBudgetPage> createState() => _JoinBudgetPageState();
}

class _JoinBudgetPageState extends State<JoinBudgetPage> {
  /// Vrai entre l'envoi et la réponse : le bloc est partagé par toute l'app,
  /// un simple rafraîchissement (status success) faisait afficher un FAUX
  /// succès et fermer l'écran avant même que l'utilisateur n'ait rien envoyé.
  bool _awaitingSubmit = false;

  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<LogService>().info(
        'Affichage page rejoindre budget',
        component: 'JoinBudgetPage',
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

    return BlocListener<BudgetsBloc, BudgetsState>(
      listener: (context, state) {
        if (!_awaitingSubmit) return;
        if (state.status != BudgetsStatus.loading) _awaitingSubmit = false;
        if (state.status == BudgetsStatus.success) {
          getIt<AnalyticsManager>().trackEvent(
            feature: 'Budgets',
            action: 'join_success',
          );
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.successJoinBudget)));
          context.popOrGo(RouteConstants.budgets, true);
        } else if (state.status == BudgetsStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? l10n.genericError)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(title: Text(l10n.joinBudget)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.enterInviteCode, style: AppTextStyles.h2),
              const SizedBox(height: 8),
              Text(
                l10n.joinBudgetDescription,
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
              BlocBuilder<BudgetsBloc, BudgetsState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state.status == BudgetsStatus.loading
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
                              'Action: Tentative de rejoindre budget $code',
                              component: 'JoinBudgetPage',
                            );
                            _awaitingSubmit = true;
                            context.read<BudgetsBloc>().add(
                              JoinBudgetRequested(code),
                            );
                          },
                    child: state.status == BudgetsStatus.loading
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
