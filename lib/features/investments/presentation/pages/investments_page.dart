import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../di/injection.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../bloc/investments_bloc.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/utils/currency_helper.dart';

import 'package:showcaseview/showcaseview.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../core/services/log_service.dart';

import '../../../system/presentation/bloc/system_bloc.dart';
import '../../../../core/widgets/feature_disabled_widget.dart';

class InvestmentsPage extends StatelessWidget {
  const InvestmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<InvestmentsBloc>()..add(const LoadInvestments()),
      child: const InvestmentsView(),
    );
  }
}

class InvestmentsView extends StatefulWidget {
  const InvestmentsView({super.key});

  @override
  State<InvestmentsView> createState() => _InvestmentsViewState();
}

class _InvestmentsViewState extends State<InvestmentsView> {
  final GlobalKey _premiumKey = GlobalKey();
  final GlobalKey _listKey = GlobalKey();
  final GlobalKey _addKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    getIt<LogService>().info(
      'Affichage de la page des investissements.',
      component: 'InvestmentsPage',
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTutorial();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.watch<TutorialService>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTutorial();
    });
  }

  /// La cible [_listKey] n'existe que lorsqu'il y a déjà au moins un
  /// investissement (sinon c'est l'état vide qui s'affiche) : on la saute et
  /// on ne montre que [_addKey] si le portefeuille est encore vide, sinon la
  /// séquence resterait bloquée dès la première étape.
  void _startTutorial() {
    final tutorialService = getIt<TutorialService>();
    if (tutorialService.hasSeenTutorial('investments')) return;
    if (ModalRoute.of(context)?.isCurrent != true) return;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final authState = context.read<AuthBloc>().state;
      final isPremium = authState.authResponse?.user.isPremium ?? false;

      if (!isPremium) {
        tutorialService.startTutorial(context, 'investments', [_premiumKey]);
        return;
      }
      final hasInvestments = context
          .read<InvestmentsBloc>()
          .state
          .investments
          .isNotEmpty;
      tutorialService.startTutorial(context, 'investments', [
        if (hasInvestments) _listKey,
        _addKey,
      ]);
    });
  }

  @override
  void dispose() {
    getIt<TutorialService>().cancelActiveTutorial(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SystemBloc, SystemState>(
      builder: (context, systemState) {
        final featureStatus = context.read<SystemBloc>().getFeatureStatus(
          systemState.featureFlags.featInvestments,
        );

        if (featureStatus == FeatureStatus.disabled) {
          return FeatureDisabledWidget(title: l10n.myInvestments);
        }

        if (featureStatus == FeatureStatus.updateRequired) {
          return FeatureDisabledWidget(
            title: l10n.myInvestments,
            isUpdateRequired: true,
          );
        }

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: Text(l10n.myInvestments),
            actions: [
              Showcase(
                key: _addKey,
                title: l10n.tutorialAddInvestmentTitle,
                description: l10n.tutorialAddInvestmentDesc,
                child: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () =>
                      context.push('${RouteConstants.investments}/add'),
                ),
              ),
            ],
          ),
          body: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              final isPremium = authState.authResponse?.user.isPremium ?? false;

              if (!isPremium) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_outline,
                          size: 80,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          AppLocalizations.of(context)!.premiumWelcomeTitle,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.h3,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppLocalizations.of(
                            context,
                          )!.investmentsPremiumRestriction,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Showcase(
                          key: _premiumKey,
                          title: AppLocalizations.of(
                            context,
                          )!.tutorialSubscriptionTitle,
                          description: AppLocalizations.of(
                            context,
                          )!.tutorialSubscriptionDesc,
                          child: AppButton(
                            text: AppLocalizations.of(
                              context,
                            )!.upgradeToPremium,
                            onPressed: () =>
                                context.push(RouteConstants.subscription),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return BlocConsumer<InvestmentsBloc, InvestmentsState>(
                listenWhen: (previous, current) =>
                    current.status == InvestmentsStatus.loaded &&
                    previous.status != InvestmentsStatus.loaded,
                listener: (context, state) {
                  // La liste ne monte son Showcase qu'une fois les
                  // investissements chargés : on retente ici dès que c'est
                  // le cas (utile si le portefeuille se remplit après coup).
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _startTutorial();
                  });
                },
                builder: (context, state) {
                  if (state.status == InvestmentsStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.status == InvestmentsStatus.error) {
                    return Center(
                      child: Text(
                        state.errorMessage ??
                            AppLocalizations.of(context)!.errorOccurred,
                      ),
                    );
                  } else if (state.investments.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: state.investments.length,
                    itemBuilder: (context, index) {
                      final investment = state.investments[index];
                      final widget = _buildInvestmentCard(context, investment);

                      final dismissible = Dismissible(
                        key: Key(investment.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.error,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.onError,
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          return await _showDeleteConfirmation(context);
                        },
                        onDismissed: (direction) {
                          getIt<LogService>().info(
                            'Action: Suppression investissement ${investment.id}',
                            component: 'InvestmentsPage',
                          );
                          context.read<InvestmentsBloc>().add(
                            DeleteInvestment(investment.id),
                          );
                        },
                        child: widget,
                      );

                      if (index == 0) {
                        return Showcase(
                          key: _listKey,
                          title: AppLocalizations.of(
                            context,
                          )!.tutorialInvestmentsTitle,
                          description: AppLocalizations.of(
                            context,
                          )!.tutorialInvestmentsDesc,
                          child: dismissible,
                        );
                      }

                      return dismissible;
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.trending_up,
            size: 80,
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noInvestments,
            style: AppTextStyles.h3.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.startBuildingPortfolio,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.push('${RouteConstants.investments}/add'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Text(AppLocalizations.of(context)!.addInvestment),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentCard(BuildContext context, dynamic investment) {
    final isPositive = investment.roi >= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getIconColor(
                context,
                investment.type,
              ).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIcon(investment.type),
              color: _getIconColor(context, investment.type),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  investment.name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _getTypeName(context, investment.type),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyHelper.formatAmount(
                  investment.currentAmount,
                  currencyCode: investment.currency,
                ),
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 14,
                    color: isPositive
                        ? AppColors.success
                        : Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${investment.roi.toStringAsFixed(1)}%',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isPositive
                          ? AppColors.success
                          : Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'crypto':
        return Icons.currency_bitcoin;
      case 'stock':
        return Icons.show_chart;
      case 'real_estate':
        return Icons.home_work_outlined;
      default:
        return Icons.savings_outlined;
    }
  }

  Color _getIconColor(BuildContext context, String type) {
    switch (type) {
      case 'crypto':
        return AppColors.warning;
      case 'stock':
        return AppColors.info;
      case 'real_estate':
        return Theme.of(context).colorScheme.tertiary;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  String _getTypeName(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case 'crypto':
        return l10n.cryptoCurrency;
      case 'stock':
        return l10n.stockMarket;
      case 'real_estate':
        return l10n.realEstate;
      default:
        return l10n.other;
    }
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.delete),
        content: Text(
          AppLocalizations.of(context)!.deleteInvestmentConfirmation,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }
}
