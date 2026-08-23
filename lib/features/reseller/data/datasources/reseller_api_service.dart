import 'package:chopper/chopper.dart';
import '../../../../core/network/models/base_response.dart';

part 'reseller_api_service.chopper.dart';

@ChopperApi()
abstract class ResellerApiService extends ChopperService {
  static ResellerApiService create([ChopperClient? client]) =>
      _$ResellerApiService(client);

  @GET(path: '/reseller/dashboard')
  Future<Response<BaseResponse<Map<String, dynamic>>>> getDashboardStats();

  @GET(path: '/reseller/accounts')
  Future<Response<BaseListResponse<Map<String, dynamic>>>> getAccounts();

  @POST(path: '/reseller/accounts')
  Future<Response<BaseResponse<Map<String, dynamic>>>> createAccount(
    @Body() Map<String, dynamic> body,
  );

  @GET(path: '/reseller/accounts/{id}/vault')
  Future<Response<BaseResponse<Map<String, dynamic>>>> unlockVault(
    @Path('id') String id,
  );

  @POST(path: '/reseller/accounts/{id}/slots')
  Future<Response<BaseResponse<Map<String, dynamic>>>> addSlot(
    @Path('id') String accountId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE(path: '/reseller/slots/{id}')
  Future<Response<BaseResponse<Map<String, dynamic>>>> deleteSlot(
    @Path('id') String slotId,
  );

  @DELETE(path: '/reseller/accounts/{id}')
  Future<Response<BaseResponse<Map<String, dynamic>>>> deleteAccount(
    @Path('id') String id,
  );

  @POST(path: '/reseller/slots/{id}/pay')
  Future<Response<BaseResponse<Map<String, dynamic>>>> recordSlotPayment(
    @Path('id') String slotId,
    @Body() Map<String, dynamic> body,
  );
}
