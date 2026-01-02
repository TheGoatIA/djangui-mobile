import 'package:chopper/chopper.dart';
import '../models/insight_model.dart';

part 'insight_api_service.chopper.dart';

@ChopperApi(baseUrl: '/insights')
abstract class InsightApiService extends ChopperService {
  static InsightApiService create([ChopperClient? client]) =>
      _$InsightApiService(client);

  @Get(path: '/distribution')
  Future<Response<List<CategoryDistributionModel>>> getCategoryDistribution(
    @Query('period') String period,
  );

  @Get(path: '/trends')
  Future<Response<List<SpendingTrendModel>>> getSpendingTrends(
    @Query('period') String period,
  );
}
