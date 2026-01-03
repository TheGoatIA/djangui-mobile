import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../di/injection.dart';
import '../bloc/insights_bloc.dart';
import '../bloc/insights_event.dart';
import '../bloc/insights_state.dart';
import '../../data/models/insight_model.dart';
import '../../../../l10n/app_localizations.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<InsightsBloc>()..add(const GetInsightsRequested()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.insightsTitle),
        ),
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
                  _buildPeriodSelector(context, state.period),
                  const SizedBox(height: 24),
                  _buildSectionTitle(
                    AppLocalizations.of(context)!.spendingDistribution,
                  ),
                  const SizedBox(height: 16),
                  _buildPieChartCard(state.distribution, context),
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
      selectedColor: AppColors.primary.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : Colors.grey[600],
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: data.isEmpty
          ? Center(child: Text(AppLocalizations.of(context)!.noDataAvailable))
          : PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 40,
                sections: data.map((item) {
                  return PieChartSectionData(
                    color: _parseColor(item.color),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: trends.isEmpty
          ? Center(child: Text(AppLocalizations.of(context)!.noDataAvailable))
          : LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: trends.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.amount);
                    }).toList(),
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 4,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withOpacity(0.1),
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
        ...distribution.map((item) => _buildCategoryItem(item)).toList(),
      ],
    );
  }

  Widget _buildCategoryItem(CategoryDistributionModel item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: _parseColor(item.color),
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

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return AppColors.primary;
    }
  }
}
