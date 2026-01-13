part of 'subscription_bloc.dart';

abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object?> get props => [];
}

class GetSubscriptionsRequested extends SubscriptionEvent {}

class AddSubscriptionRequested extends SubscriptionEvent {
  final SubscriptionModel subscription;
  const AddSubscriptionRequested(this.subscription);

  @override
  List<Object?> get props => [subscription];
}

class UpdateSubscriptionRequested extends SubscriptionEvent {
  final String id;
  final SubscriptionModel subscription;
  const UpdateSubscriptionRequested(this.id, this.subscription);

  @override
  List<Object?> get props => [id, subscription];
}

class DeleteSubscriptionRequested extends SubscriptionEvent {
  final String id;
  const DeleteSubscriptionRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class DetectSubscriptionsRequested extends SubscriptionEvent {}
