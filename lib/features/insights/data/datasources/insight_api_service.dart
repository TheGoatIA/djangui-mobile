import 'package:chopper/chopper.dart';
import 'package:djangui/core/constants/api_constants.dart';

part 'insight_api_service.chopper.dart';

@ChopperApi()
abstract class InsightApiService extends ChopperService {
  static InsightApiService create([ChopperClient? client]) =>
      _$InsightApiService(client);

  @Get(path: ApiConstants.reportAnalysis)
  Future<Response<dynamic>> getSpendingAnalysis({
    @Query('month') int? month,
    @Query('year') int? year,
  });

  @Get(path: ApiConstants.reportDashboard)
  Future<Response<dynamic>> getDashboardSummary();

  @Get(path: ApiConstants.reportNarrative)
  Future<Response<dynamic>> getNarrative({
    @Query('month') int? month,
    @Query('year') int? year,
  });
}
