import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/insight_repository.dart';
import '../../data/models/insight_model.dart';
import 'insights_event.dart';
import 'insights_state.dart';

@injectable
class InsightsBloc extends Bloc<InsightsEvent, InsightsState> {
  final InsightRepository _insightRepository;

  InsightsBloc(this._insightRepository) : super(InsightsState.initial()) {
    on<GetInsightsRequested>(_onGetInsightsRequested);
  }

  Future<void> _onGetInsightsRequested(
    GetInsightsRequested event,
    Emitter<InsightsState> emit,
  ) async {
    emit(state.copyWith(status: InsightsStatus.loading, period: event.period));

    // Parse period (assuming 'month' for now or default to current)
    final now = DateTime.now();
    final result = await _insightRepository.getSpendingAnalysis(
      month: now.month,
      year: now.year,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: InsightsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (data) {
        // Adapt dynamic data to models if possible
        // Assuming data structure: { 'distribution': [], 'trends': [] }
        final distributionList = <CategoryDistributionModel>[];
        final trendsList = <SpendingTrendModel>[];

        if (data is Map<String, dynamic>) {
          if (data['distribution'] is List) {
            distributionList.addAll(
              (data['distribution'] as List).map(
                (e) => CategoryDistributionModel.fromJson(e),
              ),
            );
          }
          if (data['trends'] is List) {
            trendsList.addAll(
              (data['trends'] as List).map(
                (e) => SpendingTrendModel.fromJson(e),
              ),
            );
          }
        }

        emit(
          state.copyWith(
            status: InsightsStatus.success,
            distribution: distributionList,
            trends: trendsList,
          ),
        );
      },
    );
  }
}
