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
import '../../data/datasources/ai_remote_datasource.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/theme/app_shadows.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../../core/services/tutorial_service.dart';

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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.insightsTitle)),
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
                  title: AppLocalizations.of(context)!.tutorialInsightsTitle,
                  description: AppLocalizations.of(
                    context,
                  )!.tutorialInsightsDesc,
                  child: _buildPeriodSelector(context, state.period),
                ),
                const SizedBox(height: 24),
                Showcase(
                  key: _aiReportKey,
                  title: AppLocalizations.of(context)!.aiAnalysisTitle,
                  description: AppLocalizations.of(
                    context,
                  )!.aiAnalysisPremiumRestriction,
                  child: _buildAINarrativeCard(context),
                ),
                const SizedBox(height: 32),
                _buildSectionTitle(
                  AppLocalizations.of(context)!.spendingDistribution,
                ),
                const SizedBox(height: 16),
                Showcase(
                  key: _chartsKey,
                  title: AppLocalizations.of(context)!.spendingDistribution,
                  description: AppLocalizations.of(
                    context,
                  )!.spendingDistribution,
                  child: _buildPieChartCard(state.distribution, context),
                ),
                const SizedBox(height: 32),
                _buildSectionTitle(
                  AppLocalizations.of(context)!.spendingTrends,
                ),
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
                    title: '${item.percentage.toStringAsFixed(0)}%',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 12,
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
    List<SpendingTrendModel> trends,
    BuildContext context,
  ) {
    return Container(
      height: 250,
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
      child: trends.isEmpty
          ? Center(child: Text(AppLocalizations.of(context)!.noDataAvailable))
          : LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: trends.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.amount);
                    }).toList(),
                    isCurved: true,
                    color: Theme.of(context).colorScheme.primary,
                    barWidth: 4,
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
          Text(
            '${item.amount.toStringAsFixed(0)} FCFA',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
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

    return FutureBuilder<String>(
      future: getIt<AIRemoteDataSource>().getNarrativeReport(),
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;

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
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.2),
            ),
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
                  Text(
                    AppLocalizations.of(context)!.aiAnalysisTitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (isLoading)
                const LinearProgressIndicator(minHeight: 2)
              else
                Text(
                  snapshot.data ??
                      AppLocalizations.of(context)!.aiAnalysisUnavailable,
                  style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
                ),
            ],
          ),
        );
      },
    );
  }

  Color _parseColor(BuildContext context, String colorString) {
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Theme.of(context).colorScheme.primary;
    }
  }
}
