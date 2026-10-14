import 'package:chopper/chopper.dart';
import 'package:kauri/core/constants/api_constants.dart';

part 'payment_api_service.chopper.dart';

@ChopperApi()
abstract class PaymentApiService extends ChopperService {
  @POST(path: ApiConstants.notchPayInit)
  Future<Response<Map<String, dynamic>>> initializeNotchPay(
    @Body() Map<String, dynamic> body,
  );

  @POST(path: ApiConstants.stripeCheckout)
  Future<Response<Map<String, dynamic>>> createStripeCheckout(
    @Body() Map<String, dynamic> body,
  );

  @GET(path: ApiConstants.verifyPayment)
  Future<Response<Map<String, dynamic>>> verifyTransaction(
    @Path('reference') String reference,
  );

  @GET(path: ApiConstants.paymentHistory)
  Future<Response<Map<String, dynamic>>> getPaymentHistory({
    @Query('type') String? type,
  });

  @POST(path: ApiConstants.cancelSubscription)
  Future<Response<Map<String, dynamic>>> cancelSubscription();

  @POST(path: ApiConstants.paySubscriptionWallet)
  Future<Response<Map<String, dynamic>>> paySubscriptionWithWallet({
    @Body() Map<String, dynamic>? body,
  });

  @GET(path: ApiConstants.subscriptionPlans)
  Future<Response<Map<String, dynamic>>> getPlansConfig();

  static PaymentApiService create(ChopperClient client) =>
      _$PaymentApiService(client);
}
