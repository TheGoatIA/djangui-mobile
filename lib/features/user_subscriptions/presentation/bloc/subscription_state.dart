part of 'subscription_bloc.dart';

enum SubscriptionStatus { initial, loading, success, failure }

class SubscriptionState extends Equatable {
  final SubscriptionStatus status;
  final List<SubscriptionModel> subscriptions;
  final List<SubscriptionSuggestion> suggestions;
  final String? errorMessage;

  const SubscriptionState({
    this.status = SubscriptionStatus.initial,
    this.subscriptions = const [],
    this.suggestions = const [],
    this.errorMessage,
  });

  SubscriptionState copyWith({
    SubscriptionStatus? status,
    List<SubscriptionModel>? subscriptions,
    List<SubscriptionSuggestion>? suggestions,
    String? errorMessage,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      subscriptions: subscriptions ?? this.subscriptions,
      suggestions: suggestions ?? this.suggestions,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, subscriptions, suggestions, errorMessage];
}
