import 'package:chopper/chopper.dart' hide HttpLoggingInterceptor;
import '../constants/api_constants.dart';
import 'interceptors.dart';

class DjanguiApiClient {
  static ChopperClient create() {
    return ChopperClient(
      baseUrl: Uri.parse(ApiConstants.baseUrl),
      interceptors: [AuthInterceptor(), HttpLoggingInterceptor()],
      converter: const JsonConverter(),
      errorConverter: const JsonConverter(),
    );
  }
}
