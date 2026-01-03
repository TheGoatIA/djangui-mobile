import 'package:chopper/chopper.dart' hide HttpLoggingInterceptor;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'interceptors.dart';

class DjanguiApiClient {
  static ChopperClient create() {
    final baseUrl =
        dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api/v1';

    return ChopperClient(
      baseUrl: Uri.parse(baseUrl),
      interceptors: [AuthInterceptor(), HttpLoggingInterceptor()],
      converter: const JsonConverter(),
      errorConverter: const JsonConverter(),
    );
  }
}
