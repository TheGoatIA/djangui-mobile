import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/insight_repository.dart';
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

    final distributionResult = await _insightRepository.getCategoryDistribution(
      event.period,
    );
    final trendsResult = await _insightRepository.getSpendingTrends(
      event.period,
    );

    distributionResult.fold(
      (failure) => emit(
        state.copyWith(
          status: InsightsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (distribution) {
        trendsResult.fold(
          (failure) => emit(
            state.copyWith(
              status: InsightsStatus.error,
              errorMessage: failure.message,
            ),
          ),
          (trends) => emit(
            state.copyWith(
              status: InsightsStatus.success,
              distribution: distribution,
              trends: trends,
            ),
          ),
        );
      },
    );
  }
}
