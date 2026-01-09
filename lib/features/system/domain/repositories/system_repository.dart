import '../../data/models/version_check_response.dart';
import '../../data/models/public_settings_model.dart';

abstract class SystemRepository {
  Future<VersionCheckResponse> checkVersion();
  Future<PublicSettingsModel> getPublicSettings();
}
