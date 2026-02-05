import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_text_styles.dart';
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
import 'package:showcaseview/showcaseview.dart';
import '../../../../core/services/tutorial_service.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';
import '../../../../core/utils/currency_helper.dart';
import '../../../system/presentation/bloc/system_bloc.dart';
import '../../../../core/widgets/feature_disabled_widget.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTutorial();
      getIt<AnalyticsManager>().trackEvent(feature: 'Insights', action: 'view');
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
    try {
      ShowCaseWidget.of(context).dismiss();
    } catch (_) {}
    super.dispose();
  }

  void _startTutorial() {
    final tutorialService = getIt<TutorialService>();
    if (!tutorialService.hasSeenTutorial('insights')) {
      if (ModalRoute.of(context)?.isCurrent != true) return;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        ShowCaseWidget.of(
          context,
        ).startShowCase([_periodKey, _aiReportKey, _chartsKey]);
        tutorialService.markTutorialAsSeen('insights');
      });
    }
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
          body: BlocBuilder<InsightsBloc, InsightsState>(
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
                    Showcase(
                      key: _periodKey,
                      title: l10n.tutorialInsightsTitle,
                      description: l10n.tutorialInsightsDesc,
                      child: _buildPeriodSelector(context, state.period),
                    ),
                    const SizedBox(height: 24),
                    Showcase(
                      key: _aiReportKey,
                      title: l10n.aiAnalysisTitle,
                      description: l10n.aiAnalysisPremiumRestriction,
                      child: _buildAINarrativeCard(context),
                    ),
                    const SizedBox(height: 32),
                    _buildSectionTitle(l10n.spendingDistribution),
                    const SizedBox(height: 16),
                    Showcase(
                      key: _chartsKey,
                      title: l10n.spendingDistribution,
                      description: l10n.spendingDistribution,
                      child: _buildPieChartCard(state.distribution, context),
                    ),
                    const SizedBox(height: 32),
                    _buildSectionTitle(l10n.spendingTrends),
                    const SizedBox(height: 16),
                    _buildLineChartCard(state.trends, context),
                    const SizedBox(height: 32),
                    _buildTopCategories(state.distribution, context),
                  ],
                ),
              );
            },
          ),
        );
      },
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
}
