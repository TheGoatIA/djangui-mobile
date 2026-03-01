import 'package:chopper/chopper.dart';
import '../../../../core/network/models/base_response.dart';
import '../models/fintech_models.dart';

part 'fintech_api_service.chopper.dart';

@ChopperApi(baseUrl: '/fintech')
abstract class FintechApiService extends ChopperService {
  static FintechApiService create([ChopperClient? client]) =>
      _$FintechApiService(client);

  @Get(path: '/wallet/balance')
  Future<Response<BaseResponse<Map<String, dynamic>>>> getBalance();

  @Get(path: '/wallet/transactions')
  Future<Response<BaseResponse<FintechTransactionsResponseModel>>>
  getTransactions();

  @Post(path: '/payout/withdraw')
  Future<Response<BaseResponse<Map<String, dynamic>>>> withdraw(
    @Body() Map<String, dynamic> body,
  );

  @Get(path: '/invoice/{id}')
  Future<Response<BaseResponse<Map<String, dynamic>>>> getInvoice(
    @Path('id') String id,
  );
}
