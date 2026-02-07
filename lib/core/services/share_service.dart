import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:kauri/di/injection.dart';
import 'package:kauri/core/services/log_service.dart';
import 'package:share_plus/share_plus.dart';
import '../../features/goals/data/models/goal_model.dart';
import 'package:uuid/uuid.dart';

@lazySingleton
/// Service gérant le partage de contenu et la génération de liens profonds (Deep Links).
@lazySingleton
class ShareService {
  /// Partage un objectif financier avec d'autres utilisateurs.
  /// Génère un lien 'kauri://share/goal' encodé en Base64 contenant les détails de l'objectif.
  Future<void> shareGoal(GoalModel goal) async {
    getIt<LogService>().info(
      'Partage objectif: ${goal.name}',
      component: 'ShareService',
    );
    // Lors du partage, on génère un nouvel ID pour éviter les collisions chez le receveur
    final sharedGoal = goal.copyWith(
      id: const Uuid().v4(),
      currentAmount: 0, // Repartir à zéro pour l'épargne du receveur
    );

    final jsonString = jsonEncode(sharedGoal.toJson());
    final base64Data = base64Encode(utf8.encode(jsonString));
    final deepLink = 'kauri://share/goal?data=$base64Data';

    await SharePlus.instance.share(
      ShareParams(
        text:
            'Rejoins mon objectif financier "${goal.name}" sur Kauri !\n\nClique ici pour l\'importer : $deepLink',
        subject: 'Objectif Kauri: ${goal.name}',
      ),
    );
  }

  /// Décode les données d'objectif reçues via un jeton Base64 issu d'un lien profond.
  GoalModel? parseGoalFromToken(String token) {
    try {
      final jsonString = utf8.decode(base64Decode(token));
      final jsonMap = jsonDecode(jsonString);
      return GoalModel.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }

  /// Partage une invitation pour rejoindre un groupe de tontine via son code unique.
  Future<void> shareTontineInvite(String code) async {
    getIt<LogService>().info(
      'Partage invitation tontine: $code',
      component: 'ShareService',
    );
    await SharePlus.instance.share(
      ShareParams(
        text: 'Rejoins ma tontine sur Kauri avec le code: $code',
        subject: 'Invitation Tontine Kauri',
      ),
    );
  }
}
