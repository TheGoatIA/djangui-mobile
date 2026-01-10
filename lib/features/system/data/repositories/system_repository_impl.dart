import 'dart:io';
import 'package:kauri/features/system/data/models/version_check_response.dart';
import 'package:kauri/features/system/data/models/public_settings_model.dart';
import 'package:kauri/features/system/data/models/country_model.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/network/api_response_extensions.dart';
import '../../data/datasources/system_api_service.dart';
import '../../domain/repositories/system_repository.dart';

@LazySingleton(as: SystemRepository)
class SystemRepositoryImpl implements SystemRepository {
  final SystemApiService _apiService;

  SystemRepositoryImpl(this._apiService);

  @override
  Future<VersionCheckResponse> checkVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final platform = Platform.isAndroid ? 'android' : 'ios';
    final version = packageInfo.version;

    final response = await _apiService.checkVersion(platform, version);

    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      // In case of error (network, server), we assume no update is needed to not block user
      // Or we could throw an exception if we want to handle it upstream
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<PublicSettingsModel> getPublicSettings() async {
    final response = await _apiService.getPublicSettings();
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<List<CountryModel>> getCountries() async {
    final response = await _apiService.getCountries();
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!.countries;
    } else {
      throw Exception(response.errorMessage);
    }
  }
}
