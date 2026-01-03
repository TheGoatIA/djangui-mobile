import 'package:chopper/chopper.dart';
import 'package:djangui/core/constants/api_constants.dart';
import 'package:djangui/features/investments/data/models/investment_model.dart';

part 'investment_api_service.chopper.dart';

@ChopperApi()
abstract class InvestmentApiService extends ChopperService {
  @Get(path: ApiConstants.investments)
  Future<Response<List<InvestmentModel>>> getInvestments();

  @Post(path: ApiConstants.investments)
  Future<Response<InvestmentModel>> createInvestment(
    @Body() Map<String, dynamic> body,
  );

  @Delete(path: '${ApiConstants.investments}/{id}')
  Future<Response<void>> deleteInvestment(@Path('id') String id);

  static InvestmentApiService create(ChopperClient client) =>
      _$InvestmentApiService(client);
}
