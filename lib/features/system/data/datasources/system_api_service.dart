import 'package:chopper/chopper.dart';
import '../../../../core/network/models/base_response.dart';
import '../models/version_check_response.dart';

part 'system_api_service.chopper.dart';

@ChopperApi(baseUrl: '/v1/system')
abstract class SystemApiService extends ChopperService {
  @Get(path: '/version-check')
  Future<Response<BaseResponse<VersionCheckResponse>>> checkVersion(
    @Query('platform') String platform,
    @Query('version') String version,
  );

  static SystemApiService create(ChopperClient client) =>
      _$SystemApiService(client);
}
