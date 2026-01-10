import '../../data/models/version_check_response.dart';
import '../../data/models/public_settings_model.dart';
import '../../data/models/country_model.dart';

abstract class SystemRepository {
  Future<VersionCheckResponse> checkVersion();
  Future<PublicSettingsModel> getPublicSettings();
  Future<List<CountryModel>> getCountries();
}
