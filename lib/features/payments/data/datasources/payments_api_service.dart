import 'package:chopper/chopper.dart';
import '../models/payment_model.dart';
import '../../../../core/network/models/base_response.dart';

part 'payments_api_service.chopper.dart';

@ChopperApi(baseUrl: '/payments')
abstract class PaymentsApiService extends ChopperService {
  static PaymentsApiService create([ChopperClient? client]) =>
      _$PaymentsApiService(client);

  @POST(path: '/checkout/stripe')
  Future<Response<BaseResponse<PaymentInitResponseModel>>> initStripeCheckout(
    @Body() Map<String, dynamic> body,
  );

  @POST(path: '/init/notchpay')
  Future<Response<BaseResponse<PaymentInitResponseModel>>> initNotchPayPayment(
    @Body() Map<String, dynamic> body,
  );

  @GET(path: '/verify/{reference}')
  Future<Response<BaseResponse<Map<String, dynamic>>>> verifyPayment(
    @Path('reference') String reference,
  );
}
