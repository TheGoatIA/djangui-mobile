import 'package:chopper/chopper.dart';
import '../../../../core/network/models/base_response.dart';
import '../models/fintech_models.dart';

part 'fintech_api_service.chopper.dart';

@ChopperApi(baseUrl: '/fintech')
abstract class FintechApiService extends ChopperService {
  static FintechApiService create([ChopperClient? client]) =>
      _$FintechApiService(client);

  @GET(path: '/wallet/balance')
  Future<Response<BaseResponse<Map<String, dynamic>>>> getBalance();

  @GET(path: '/wallet/transactions')
  Future<Response<BaseResponse<FintechTransactionsResponseModel>>>
  getTransactions();

  @POST(path: '/payout/withdraw')
  Future<Response<BaseResponse<Map<String, dynamic>>>> withdraw(
    @Body() Map<String, dynamic> body,
  );

  @GET(path: '/invoice/{id}')
  Future<Response<BaseResponse<InvoiceResponseModel>>> getInvoice(
    @Path('id') String id,
  );
}

