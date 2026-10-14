import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../di/injection.dart';
import '../bloc/insights_bloc.dart';
import '../bloc/insights_event.dart';
import '../bloc/insights_state.dart';
import '../../data/models/insight_model.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../reports/data/models/reports_model.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/widgets/tutorial/tutorial_step.dart';
import '../../../../core/services/tutorial_service.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';
import '../../../../core/utils/currency_helper.dart';
import '../../../system/presentation/bloc/system_bloc.dart';
import '../../../../core/widgets/feature_disabled_widget.dart';
import '../../../../core/services/log_service.dart';
import '../utils/report_pdf_builder.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<InsightsBloc>()..add(const GetInsightsRequested()),
      child: const InsightsView(),
    );
  }
}

class InsightsView extends StatefulWidget {
  const InsightsView({super.key});

  @override
  State<InsightsView> createState() => _InsightsViewState();
}

class _InsightsViewState extends State<InsightsView> {
  final GlobalKey _periodKey = GlobalKey();
  final GlobalKey _aiReportKey = GlobalKey();
  final GlobalKey _chartsKey = GlobalKey();
  bool _isGeneratingPdf = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTutorial();
      getIt<AnalyticsManager>().trackEvent(feature: 'Insights', action: 'view');
      getIt<LogService>().info(
        'Affichage de la page Insights.',
        component: 'InsightsPage',
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Watch for tutorial reset
    context.watch<TutorialService>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTutorial();
    });
  }

  @override
  void dispose() {
    getIt<TutorialService>().cancelActiveTutorial(context);
    super.dispose();
  }

  void _startTutorial() {
    final tutorialService = getIt<TutorialService>();
    if (tutorialService.hasSeenTutorial('insights')) return;
    if (ModalRoute.of(context)?.isCurrent != true) return;
    // Les 3 cibles ne sont construites qu'une fois le chargement initial
    // terminé (voir le spinner plein écran dans build()) : on attend un court
    // instant, et on retentera de toute façon via le BlocListener ci-dessous
    // dès que l'état passe à `success`.
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      tutorialService.startTutorial(context, 'insights', [
        TutorialStep(
          targetKey: _periodKey,
          title: l10n.tutorialInsightsTitle,
          description: l10n.tutorialInsightsDesc,
        ),
        TutorialStep(
          targetKey: _aiReportKey,
          title: l10n.tutorialAiReportTitle,
          description: l10n.tutorialAiReportDesc,
        ),
        TutorialStep(
          targetKey: _chartsKey,
          title: l10n.tutorialChartsTitle,
          description: l10n.tutorialChartsDesc,
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SystemBloc, SystemState>(
      builder: (context, systemState) {
        final featureStatus = context.read<SystemBloc>().getFeatureStatus(
          systemState.featureFlags.aiInsights,
        );

        if (featureStatus == FeatureStatus.disabled) {
          return FeatureDisabledWidget(title: l10n.insightsTitle);
        }

        if (featureStatus == FeatureStatus.updateRequired) {
          return FeatureDisabledWidget(
            title: l10n.insightsTitle,
            isUpdateRequired: true,
          );
        }
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(title: Text(l10n.insightsTitle)),
          body: BlocListener<InsightsBloc, InsightsState>(
            listenWhen: (previous, current) =>
                current.status == InsightsStatus.success &&
                previous.status != InsightsStatus.success,
            listener: (context, state) {
              // Les cibles du tutoriel ne sont montées qu'une fois les
              // données chargées : on retente ici dès que c'est le cas.
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _startTutorial();
              });
            },
            child: BlocBuilder<InsightsBloc, InsightsState>(
              builder: (context, state) {
                if (state.status == InsightsStatus.loading &&
                    state.distribution.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KeyedSubtree(
                        key: _periodKey,
                        child: _buildPeriodSelector(context, state.period),
                      ),
                      if (state.status == InsightsStatus.error &&
                          state.errorMessage != null) ...[
                        const SizedBox(height: 16),
                        _buildErrorBanner(context, state),
                      ],
                      const SizedBox(height: 24),
                      KeyedSubtree(
                        key: _aiReportKey,
                        child: _buildAINarrativeCard(context),
                      ),
                      const SizedBox(height: 32),
                      _buildSectionTitle(l10n.spendingDistribution),
                      const SizedBox(height: 16),
                      KeyedSubtree(
                        key: _chartsKey,
                        child: _buildPieChartCard(state.distribution, context),
                      ),
                      const SizedBox(height: 32),
                      if (context
                              .read<AuthBloc>()
                              .state
                              .authResponse
                              ?.user
                              .isPremium ??
                          false) ...[
                        if (state.healthScoreHistory.isNotEmpty) ...[
                          _buildSectionTitle(l10n.healthScoreHistoryTitle),
                          const SizedBox(height: 16),
                          _buildHealthScoreHistoryCard(
                            state.healthScoreHistory,
                            context,
                          ),
                          const SizedBox(height: 32),
                        ],
                        _buildSectionTitle(l10n.autoBudgetTitle),
                        const SizedBox(height: 16),
                        _buildAutoBudgetCard(context),
                        const SizedBox(height: 32),
                        _buildSectionTitle(l10n.premiumReportTitle),
                        const SizedBox(height: 16),
                        _buildPremiumReportCard(context),
                        const SizedBox(height: 32),
                      ],
                      _buildSectionTitle(l10n.spendingTrends),
                      const SizedBox(height: 16),
                      _buildLineChartCard(state.trends, context),
                      const SizedBox(height: 32),
                      if (context
                              .read<AuthBloc>()
                              .state
                              .authResponse
                              ?.user
                              .isPremium ??
                          false) ...[
                        _buildSectionTitle(l10n.forecastSectionTitle),
                        const SizedBox(height: 16),
                        _buildForecastCard(state.forecast, context),
                        const SizedBox(height: 32),
                      ],
                      _buildTopCategories(state.distribution, context),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorBanner(BuildContext context, InsightsState state) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi_off_rounded, color: AppColors.error, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.insightsLoadErrorBanner,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
            ),
          ),
          TextButton(
            onPressed: () => context.read<InsightsBloc>().add(
              GetInsightsRequested(period: state.period),
            ),
            child: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildPeriodSelector(BuildContext context, String currentPeriod) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildPeriodChip(
            context,
            AppLocalizations.of(context)!.weekly,
            'weekly',
            currentPeriod,
          ),
          const SizedBox(width: 8),
          _buildPeriodChip(
            context,
            AppLocalizations.of(context)!.monthly,
            'monthly',
            currentPeriod,
          ),
          const SizedBox(width: 8),
          _buildPeriodChip(
            context,
            AppLocalizations.of(context)!.yearly,
            'yearly',
            currentPeriod,
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodChip(
    BuildContext context,
    String label,
    String value,
    String currentValue,
  ) {
    final isSelected = value == currentValue;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          getIt<AnalyticsManager>().trackEvent(
            feature: 'Insights',
            action: 'change_period',
            details: {'period': value},
          );
          getIt<LogService>().info(
            'Action: Changement de période Insights ($value)',
            component: 'InsightsPage',
          );
          context.read<InsightsBloc>().add(GetInsightsRequested(period: value));
        }
      },
      selectedColor: Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildPieChartCard(
    List<CategoryDistributionModel> data,
    BuildContext context,
  ) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.card,
      ),
      child: data.isEmpty
          ? Center(child: Text(AppLocalizations.of(context)!.noDataAvailable))
          : PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 40,
                sections: data.map((item) {
                  return PieChartSectionData(
                    color: _parseColor(context, item.color),
                    value: item.percentage,
                    title:
                        '${item.category}\n${item.percentage.toStringAsFixed(0)}%',
                    radius: 70,
                    titleStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }

  Widget _buildLineChartCard(
    List<SavingsTrendModel> trends,
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: trends.isEmpty
                ? Center(
                    child: Text(AppLocalizations.of(context)!.noDataAvailable),
                  )
                : LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: trends.asMap().entries.map((e) {
                            return FlSpot(e.key.toDouble(), e.value.income);
                          }).toList(),
                          isCurved: true,
                          color: Colors.green,
                          barWidth: 3,
                          dotData: const FlDotData(show: false),
                        ),
                        LineChartBarData(
                          spots: trends.asMap().entries.map((e) {
                            return FlSpot(e.key.toDouble(), e.value.expense);
                          }).toList(),
                          isCurved: true,
                          color: Theme.of(context).colorScheme.error,
                          barWidth: 4,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Theme.of(
                              context,
                            ).colorScheme.error.withValues(alpha: 0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(
                context,
                AppLocalizations.of(context)!.income,
                Colors.green,
              ),
              const SizedBox(width: 20),
              _buildLegendItem(
                context,
                AppLocalizations.of(context)!.expense,
                Theme.of(context).colorScheme.error,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthScoreHistoryCard(
    List<HealthScorePointModel> history,
    BuildContext context,
  ) {
    final latest = history.last.score;
    final latestColor = latest >= 70
        ? AppColors.success
        : (latest >= 40 ? Colors.orange : AppColors.error);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.financialHealthScoreLabel,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$latest/100',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: latestColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: history.length < 2
                ? Center(
                    child: Text(
                      AppLocalizations.of(context)!.healthScoreHistoryEmpty,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : LineChart(
                    LineChartData(
                      minY: 0,
                      maxY: 100,
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: history.asMap().entries.map((e) {
                            return FlSpot(
                              e.key.toDouble(),
                              e.value.score.toDouble(),
                            );
                          }).toList(),
                          isCurved: true,
                          color: latestColor,
                          barWidth: 3,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: latestColor.withValues(alpha: 0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          if (history.length >= 2) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  history.first.period,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  history.last.period,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildForecastCard(
    ForecastReportModel? forecast,
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(context)!;

    if (forecast == null || forecast.forecast.isEmpty) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadows.card,
        ),
        child: Text(
          l10n.forecastUnavailable,
          style: AppTextStyles.bodySmall.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    final points = forecast.forecast;
    final balances = points.map((p) => p.balance).toList();
    final minBalance = balances.reduce((a, b) => a < b ? a : b);
    final maxBalance = balances.reduce((a, b) => a > b ? a : b);
    // Une marge de part et d'autre évite que la courbe touche les bords du
    // graphique quand le solde projeté reste quasiment plat.
    final double padding = ((maxBalance - minBalance).abs() * 0.15)
        .clamp(100.0, double.infinity)
        .toDouble();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (forecast.criticalAlert != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.error,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${l10n.forecastCriticalAlertPrefix} ',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.error,
                            ),
                          ),
                          TextSpan(
                            text: forecast.criticalAlert!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                minY: minBalance - padding,
                maxY: maxBalance + padding,
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: points.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.balance);
                    }).toList(),
                    isCurved: true,
                    color: Theme.of(context).colorScheme.primary,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (forecast.insights.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              l10n.forecastInsightsLabel,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            ...forecast.insights.map(
              (insight) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '• ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(insight, style: AppTextStyles.bodySmall),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildTopCategories(
    List<CategoryDistributionModel> distribution,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(AppLocalizations.of(context)!.categoryDetails),
        const SizedBox(height: 16),
        ...distribution.map((item) => _buildCategoryItem(context, item)),
      ],
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    CategoryDistributionModel item,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: _parseColor(context, item.color),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(item.category, style: AppTextStyles.bodyMedium),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyHelper.formatAmount(
                  item.amount,
                  currencyCode:
                      context
                          .read<AuthBloc>()
                          .state
                          .authResponse
                          ?.user
                          .currency ??
                      'XAF',
                  locale: Localizations.localeOf(context).toString(),
                ),
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${item.percentage.toStringAsFixed(1)}%',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAINarrativeCard(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final isPremium = authState.authResponse?.user.isPremium ?? false;

    if (!isPremium) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Column(
          children: [
            Icon(
              Icons.lock_outline,
              color: Theme.of(context).colorScheme.primary,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.aiAnalysisTitle,
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.aiAnalysisPremiumRestriction,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            AppButton(
              text: AppLocalizations.of(context)!.upgradeToPremium,
              onPressed: () => context.push(RouteConstants.subscription),
            ),
          ],
        ),
      );
    }

    final state = context.watch<InsightsBloc>().state;
    final narrative = state.narrative;
    final isLoading = state.status == InsightsStatus.loading;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            Theme.of(context).colorScheme.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        ),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  narrative?.title ??
                      AppLocalizations.of(context)!.aiAnalysisTitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (narrative?.tone != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    narrative!.tone!,
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (isLoading && narrative == null)
            const LinearProgressIndicator(minHeight: 2)
          else if (narrative == null)
            Text(AppLocalizations.of(context)!.aiAnalysisUnavailable)
          else ...[
            if (narrative.healthScore != null) ...[
              _buildHealthScoreGauge(context, narrative.healthScore!),
              const SizedBox(height: 16),
            ],
            _buildMarkdownText(
              narrative.summary,
              AppTextStyles.bodyMedium.copyWith(height: 1.5),
            ),
            if (narrative.topInsights.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                "Points clés",
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              ...narrative.topInsights.map(
                (insight) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "• ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: _buildMarkdownText(
                          insight,
                          AppTextStyles.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (narrative.recommendations.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                "Recommandations de Kauri",
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 8),
              ...narrative.recommendations.map(
                (rec) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          size: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildMarkdownText(
                            rec,
                            AppTextStyles.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildHealthScoreGauge(BuildContext context, int score) {
    final clamped = score.clamp(0, 100);
    final Color scoreColor = clamped >= 70
        ? AppColors.success
        : (clamped >= 40 ? Colors.orange : AppColors.error);

    return Row(
      children: [
        SizedBox(
          width: 52,
          height: 52,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 52,
                height: 52,
                child: CircularProgressIndicator(
                  value: clamped / 100,
                  strokeWidth: 5,
                  backgroundColor: scoreColor.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                ),
              ),
              Text(
                '$clamped',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scoreColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            AppLocalizations.of(context)!.financialHealthScoreLabel,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Color _parseColor(BuildContext context, String colorString) {
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Theme.of(context).colorScheme.primary;
    }
  }

  Widget _buildMarkdownText(String text, TextStyle baseStyle) {
    final spans = <TextSpan>[];
    final regExp = RegExp(r'\*\*(.*?)\*\*');
    int lastMatchEnd = 0;

    final matches = regExp.allMatches(text);

    for (final match in matches) {
      // Add text before the match
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: baseStyle,
          ),
        );
      }
      // Add bold text
      spans.add(
        TextSpan(
          text: match.group(1),
          style: baseStyle.copyWith(fontWeight: FontWeight.bold),
        ),
      );
      lastMatchEnd = match.end;
    }

    // Add remaining text
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd), style: baseStyle));
    }

    return RichText(
      text: TextSpan(
        children: spans,
        style: baseStyle.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildAutoBudgetCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = context.read<AuthBloc>().state.authResponse?.user;
    final monthlyIncome = user?.monthlyIncome ?? 0;
    final currency = user?.currency ?? 'XAF';
    final locale = Localizations.localeOf(context).toString();

    if (monthlyIncome <= 0) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.primaryContainer.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          l10n.autoBudgetNoIncomeHint,
          style: AppTextStyles.bodyMedium,
        ),
      );
    }

    final needs = monthlyIncome * 0.5;
    final wants = monthlyIncome * 0.3;
    final savings = monthlyIncome * 0.2;

    // La comparaison au réel n'a de sens que sur le mois calendaire — le
    // revenu est par nature mensuel, contrairement au sélecteur de période
    // (hebdo/annuel) qui fausserait la proportion.
    final insightsState = context.watch<InsightsBloc>().state;
    final double? actualSpent = insightsState.period == 'monthly'
        ? insightsState.distribution.fold<double>(
            0,
            (sum, item) => sum + item.amount,
          )
        : null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_fix_high,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.autoBudgetDesc,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildBudgetLine(
            context,
            l10n.autoBudgetNeeds,
            needs,
            currency,
            locale,
            Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 10),
          _buildBudgetLine(
            context,
            l10n.autoBudgetWants,
            wants,
            currency,
            locale,
            Colors.orange,
          ),
          const SizedBox(height: 10),
          _buildBudgetLine(
            context,
            l10n.autoBudgetSavings,
            savings,
            currency,
            locale,
            AppColors.success,
          ),
          if (actualSpent != null) ...[
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Text(
              l10n.autoBudgetActualSpent(
                CurrencyHelper.formatAmount(
                  actualSpent,
                  currencyCode: currency,
                  locale: locale,
                ),
                CurrencyHelper.formatAmount(
                  monthlyIncome,
                  currencyCode: currency,
                  locale: locale,
                ),
              ),
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (actualSpent / monthlyIncome).clamp(0, 1),
                minHeight: 8,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.outlineVariant.withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  actualSpent > needs + wants
                      ? AppColors.error
                      : AppColors.success,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBudgetLine(
    BuildContext context,
    String label,
    double amount,
    String currency,
    String locale,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: AppTextStyles.bodyMedium)),
        Text(
          CurrencyHelper.formatAmount(
            amount,
            currencyCode: currency,
            locale: locale,
          ),
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPremiumReportCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final narrative = context.watch<InsightsBloc>().state.narrative;
    final rawMonth = DateFormat.MMMM(
      Localizations.localeOf(context).toString(),
    ).format(DateTime.now());
    final monthLabel = rawMonth.isEmpty
        ? rawMonth
        : '${rawMonth[0].toUpperCase()}${rawMonth.substring(1)}';

    return GestureDetector(
      onTap: (narrative == null || _isGeneratingPdf)
          ? null
          : () => _sharePremiumReportPdf(narrative, monthLabel),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade400, Colors.indigo.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.auto_awesome, color: Colors.white, size: 30),
            const SizedBox(height: 12),
            Text(
              narrative != null
                  ? l10n.premiumReportReady(monthLabel)
                  : l10n.premiumReportPreparing(monthLabel),
              style: AppTextStyles.h3.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.premiumReportDesc,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            if (narrative != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  if (_isGeneratingPdf) ...[
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.reportPdfGenerating,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ] else ...[
                    const Icon(
                      Icons.picture_as_pdf_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.premiumReportShareAction,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _sharePremiumReportPdf(
    NarrativeReportModel narrative,
    String monthLabel,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isGeneratingPdf = true);
    try {
      final bytes = await ReportPdfBuilder.build(
        narrative: narrative,
        monthLabel: monthLabel,
        keyInsightsLabel: l10n.reportPdfKeyInsights,
        recommendationsLabel: l10n.reportPdfRecommendations,
        healthScoreLabel: l10n.financialHealthScoreLabel,
        footerLabel: l10n.reportPdfGeneratedOn(
          DateFormat.yMMMMd(
            Localizations.localeOf(context).toString(),
          ).format(DateTime.now()),
        ),
      );
      await Printing.sharePdf(
        bytes: bytes,
        filename: 'kauri-rapport-$monthLabel.pdf',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.reportPdfError),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isGeneratingPdf = false);
    }
  }
}
