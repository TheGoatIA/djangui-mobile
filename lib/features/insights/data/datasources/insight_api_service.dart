import 'package:chopper/chopper.dart';
import 'package:kauri/core/constants/api_constants.dart';

part 'insight_api_service.chopper.dart';

@ChopperApi()
abstract class InsightApiService extends ChopperService {
  static InsightApiService create([ChopperClient? client]) =>
      _$InsightApiService(client);

  @GET(path: ApiConstants.reportAnalysis)
  Future<Response<dynamic>> getSpendingAnalysis({
    @Query('month') int? month,
    @Query('year') int? year,
  });

  @GET(path: ApiConstants.reportDashboard)
  Future<Response<dynamic>> getDashboardSummary();

  @GET(path: ApiConstants.reportNarrative)
  Future<Response<dynamic>> getNarrative({
    @Query('month') int? month,
    @Query('year') int? year,
  });
}
