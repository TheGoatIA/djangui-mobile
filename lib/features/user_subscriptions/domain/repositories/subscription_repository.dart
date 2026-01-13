import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/subscription_model.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, List<SubscriptionModel>>> getSubscriptions();
  Future<Either<Failure, SubscriptionModel>> getSubscriptionDetails(String id);
  Future<Either<Failure, void>> addSubscription(SubscriptionModel subscription);
  Future<Either<Failure, void>> updateSubscription(
    String id,
    SubscriptionModel subscription,
  );
  Future<Either<Failure, void>> deleteSubscription(String id);
  Future<Either<Failure, List<SubscriptionSuggestion>>> detectSubscriptions();
}
