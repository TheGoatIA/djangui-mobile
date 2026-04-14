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
  getSpendingAnalysis();

  @GET(path: '/trends')
  Future<Response<BaseListResponse<SavingsTrendModel>>> getSavingsTrend();

  @GET(path: '/narrative')
  Future<Response<BaseResponse<NarrativeReportModel>>> getNarrativeReport();

  @GET(path: '/export/csv')
  Future<Response<dynamic>> exportCsv();
}

