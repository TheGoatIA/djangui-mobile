import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../reports/domain/repositories/reports_repository.dart';
import '../../../reports/data/models/reports_model.dart';
import '../../data/models/insight_model.dart';
import 'insights_event.dart';
import 'insights_state.dart';

@injectable
class InsightsBloc extends Bloc<InsightsEvent, InsightsState> {
  final ReportsRepository _reportsRepository;

  InsightsBloc(this._reportsRepository) : super(InsightsState.initial()) {
    on<GetInsightsRequested>(_onGetInsightsRequested);
  }

  Future<void> _onGetInsightsRequested(
    GetInsightsRequested event,
    Emitter<InsightsState> emit,
  ) async {
    emit(state.copyWith(status: InsightsStatus.loading, period: event.period));

    // Fetch spending analysis, trends, and narrative in parallel
    final results = await Future.wait([
      _reportsRepository.getSpendingAnalysis(),
      _reportsRepository.getSavingsTrend(),
      _reportsRepository.getNarrativeReport(),
    ]);

    final analysisResult =
        results[0] as Either<Failure, List<SpendingAnalysisModel>>;
    final trendsResult = results[1] as Either<Failure, List<SavingsTrendModel>>;
    final narrativeResult = results[2] as Either<Failure, NarrativeReportModel>;

    analysisResult.fold(
      (failure) => emit(
        state.copyWith(
          status: InsightsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (analysisData) {
        final totalAmount = analysisData.fold<double>(
          0,
          (sum, item) => sum + item.amount,
        );

        final distributionList = analysisData.map((e) {
          final percentage = totalAmount > 0
              ? (e.amount / totalAmount) * 100
              : 0.0;
          return CategoryDistributionModel(
            category: e.category,
            amount: e.amount,
            percentage: percentage,
            color: _getCategoryColor(e.category),
          );
        }).toList();

        final finalState = state.copyWith(
          status: InsightsStatus.success,
          distribution: distributionList,
        );

        // Feed trends into state
        final stateWithTrends = trendsResult.fold(
          (failure) => finalState,
          (trends) => finalState.copyWith(trends: trends),
        );

        // Feed the narrative into the state if successful
        narrativeResult.fold(
          (failure) => emit(stateWithTrends),
          (narrative) => emit(stateWithTrends.copyWith(narrative: narrative)),
        );
      },
    );
  }

  String _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      // Use existing colors or hex strings
      case 'alimentation':
      case 'nourriture':
      case 'repas':
        return '#FF5722'; // Deep Orange
      case 'transport':
        return '#2196F3'; // Blue
      case 'logement':
      case 'loyer':
        return '#9C27B0'; // Purple
      case 'santé':
      case 'sante':
        return '#E91E63'; // Pink
      case 'loisirs':
      case 'divertissement':
        return '#FFC107'; // Amber
      case 'education':
      case 'éducation':
        return '#4CAF50'; // Green
      case 'shopping':
      case 'achats':
        return '#795548'; // Brown
      case 'services':
      case 'factures':
        return '#607D8B'; // Blue Grey
      default:
        return '#9E9E9E'; // Grey
    }
  }
}
