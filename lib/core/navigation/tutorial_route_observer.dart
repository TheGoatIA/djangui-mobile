import 'package:flutter/widgets.dart';

import '../widgets/tutorial/tutorial_overlay.dart';
import '../services/tutorial_service.dart';
import '../../di/injection.dart';

/// Ferme le tutoriel en cours dès que l'utilisateur change d'écran.
///
/// Le tutoriel est un calque global (Overlay) : sans cela, celui d'un écran
/// restait affiché par-dessus l'écran suivant (constaté en E2E : « Rejoindre
/// une tontine » par-dessus « Créer une tontine » après une navigation par
/// notification / lien). Le tutoriel n'est PAS marqué comme vu : il
/// réapparaîtra au retour sur son écran.
class TutorialRouteObserver extends NavigatorObserver {
  void _close() {
    if (!TutorialOverlayController.isShowing) return;
    final ctx = navigator?.context;
    if (ctx != null && getIt.isRegistered<TutorialService>()) {
      getIt<TutorialService>().cancelActiveTutorial(ctx);
    } else {
      TutorialOverlayController.hide();
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PageRoute) _close();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PageRoute) _close();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute is PageRoute) _close();
  }
}
