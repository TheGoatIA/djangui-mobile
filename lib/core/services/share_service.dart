import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:share_plus/share_plus.dart';
import '../../features/goals/data/models/goal_model.dart';
import 'package:uuid/uuid.dart';

@lazySingleton
class ShareService {
  Future<void> shareGoal(GoalModel goal) async {
    // We clear ID and amounts to let the receiver start fresh, or keep them?
    // User said "share objectives... or tontine plan".
    // Usually sharing a plan means sharing the Config (Target, Name, Deadline).
    // Current amount should probably be 0 for the new user.

    final sharedGoal = goal.copyWith(
      id: const Uuid().v4(), // Generate new ID to avoid collisions if imported
      currentAmount: 0,
      // We keep targetAmount, name, deadline
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

  GoalModel? parseGoalFromToken(String token) {
    try {
      final jsonString = utf8.decode(base64Decode(token));
      final jsonMap = jsonDecode(jsonString);
      return GoalModel.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }
}
