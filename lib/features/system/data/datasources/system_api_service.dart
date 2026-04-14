import 'package:chopper/chopper.dart';
import '../../../../core/network/models/base_response.dart';
import '../models/version_check_response.dart';
import '../models/public_settings_model.dart';
import '../models/country_model.dart';

part 'system_api_service.chopper.dart';

@ChopperApi(baseUrl: '/system')
abstract class SystemApiService extends ChopperService {
  @GET(path: '/version-check')
  Future<Response<BaseResponse<VersionCheckResponse>>> checkVersion(
    @Query('platform') String platform,
    @Query('version') String version,
  );

  @GET(path: '/public-settings')
  Future<Response<BaseResponse<PublicSettingsModel>>> getPublicSettings();

  @GET(path: '/countries')
  Future<Response<BaseResponse<CountryListResponse>>> getCountries();

  static SystemApiService create(ChopperClient client) =>
      _$SystemApiService(client);
}

