import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import 'package:kauri/features/analytics/data/models/analytics_models.dart';

abstract class AnalyticsRepository {
  Future<Either<Failure, void>> trackEvent(UserActivity activity);
  Future<Either<Failure, String>> startSession({
    String? deviceId,
    String? platform,
    String? appVersion,
  });
  Future<Either<Failure, void>> endSession(String sessionId);
}
