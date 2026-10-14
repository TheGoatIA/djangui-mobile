import 'package:chopper/chopper.dart';
import '../models/reports_model.dart';
import '../../../../core/network/models/base_response.dart';

part 'reports_api_service.chopper.dart';

@ChopperApi(baseUrl: '/reports')
abstract class ReportsApiService extends ChopperService {
  static ReportsApiService create([ChopperClient? client]) =>
      _$ReportsApiService(client);

  @GET(path: '/dashboard')
  Future<Response<BaseResponse<DashboardReportModel>>> getDashboardReport();

  @GET(path: '/analysis')
  Future<Response<BaseListResponse<SpendingAnalysisModel>>>
  getSpendingAnalysis({@Query('period') String? period});

  @GET(path: '/trends')
  Future<Response<BaseListResponse<SavingsTrendModel>>> getSavingsTrend({
    @Query('period') String? period,
  });

  @GET(path: '/narrative')
  Future<Response<BaseResponse<NarrativeReportModel>>> getNarrativeReport();

  @GET(path: '/health-score-history')
  Future<Response<BaseListResponse<HealthScorePointModel>>>
  getHealthScoreHistory({@Query('months') int months = 6});

  @GET(path: '/export/csv')
  Future<Response<dynamic>> exportCsv();
}

// Base URL distincte du reste des rapports : `/forecast` est monté comme un
// router Express séparé côté backend (voir forecast.routes.ts), pas sous
// `/reports`.
@ChopperApi(baseUrl: '/forecast')
abstract class ForecastApiService extends ChopperService {
  static ForecastApiService create([ChopperClient? client]) =>
      _$ForecastApiService(client);

  @GET(path: '/balance')
  Future<Response<BaseResponse<ForecastReportModel>>> getBalanceForecast();
}
