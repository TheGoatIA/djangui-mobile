import '../../data/models/version_check_response.dart';

abstract class SystemRepository {
  Future<VersionCheckResponse> checkVersion();
}
