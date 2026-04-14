import 'package:chopper/chopper.dart';
import 'package:kauri/core/constants/api_constants.dart';
import 'package:kauri/features/investments/data/models/investment_model.dart';
import 'package:kauri/core/network/models/base_response.dart';

part 'investment_api_service.chopper.dart';

@ChopperApi()
abstract class InvestmentApiService extends ChopperService {
  @GET(path: ApiConstants.investments)
  Future<Response<BaseListResponse<InvestmentModel>>> getInvestments();

  @POST(path: ApiConstants.investments)
  Future<Response<BaseResponse<InvestmentModel>>> createInvestment(
    @Body() Map<String, dynamic> body,
  );

  @DELETE(path: '${ApiConstants.investments}/{id}')
  Future<Response<BaseResponse<dynamic>>> deleteInvestment(
    @Path('id') String id,
  );

  @POST(path: '${ApiConstants.investments}/{id}/close')
  Future<Response<BaseResponse<dynamic>>> closeInvestment(
    @Path('id') String id,
  );

  @PATCH(path: '${ApiConstants.investments}/{id}/value')
  Future<Response<BaseResponse<dynamic>>> updateInvestmentValue(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  static InvestmentApiService create(ChopperClient client) =>
      _$InvestmentApiService(client);
}

