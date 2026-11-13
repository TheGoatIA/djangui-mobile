import 'package:injectable/injectable.dart';
import 'package:kauri/core/utils/app_l10n.dart';
import 'package:kauri/di/injection.dart';
import 'package:kauri/core/services/log_service.dart';
import 'package:share_plus/share_plus.dart';

/// Service gérant le partage de contenu (liens, invitations) via le
/// sélecteur de partage natif du système.
@lazySingleton
class ShareService {
  /// Partage une invitation pour rejoindre un groupe de tontine via son code unique.
  Future<void> shareTontineInvite(String code) async {
    getIt<LogService>().info(
      'Partage invitation tontine: $code',
      component: 'ShareService',
    );
    await SharePlus.instance.share(
      ShareParams(
        text: appL10n().shareTontineInviteText(code.toString()),
        subject: appL10n().shareTontineInviteSubject,
      ),
    );
  }
}
