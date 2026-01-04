import 'package:chopper/chopper.dart';
import 'package:djangui/core/constants/api_constants.dart';

part 'payment_api_service.chopper.dart';

@ChopperApi()
abstract class PaymentApiService extends ChopperService {
  @Post(path: ApiConstants.notchPayInit)
  Future<Response<Map<String, dynamic>>> initializeNotchPay(
    @Body() Map<String, dynamic> body,
  );

  @Post(path: ApiConstants.stripeCheckout)
  Future<Response<Map<String, dynamic>>> createStripeCheckout(
    @Body() Map<String, dynamic> body,
  );

  static PaymentApiService create(ChopperClient client) =>
      _$PaymentApiService(client);
}
