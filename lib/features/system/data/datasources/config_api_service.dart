import 'package:chopper/chopper.dart';
import '../../../../core/network/models/base_response.dart';
import '../models/feature_flag_model.dart';

part 'config_api_service.chopper.dart';

@ChopperApi(baseUrl: '/config')
abstract class ConfigApiService extends ChopperService {
  @GET(path: '/features')
  Future<Response<BaseResponse<FeatureFlagModel>>> getFeatureFlags();

  static ConfigApiService create(ChopperClient client) =>
      _$ConfigApiService(client);
}
