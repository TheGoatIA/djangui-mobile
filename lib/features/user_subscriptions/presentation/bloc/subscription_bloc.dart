import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/subscription_model.dart';
import '../../domain/repositories/subscription_repository.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

@injectable
class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionRepository _repository;

  SubscriptionBloc(this._repository) : super(const SubscriptionState()) {
    on<GetSubscriptionsRequested>(_onGetSubscriptionsRequested);
    on<AddSubscriptionRequested>(_onAddSubscriptionRequested);
    on<UpdateSubscriptionRequested>(_onUpdateSubscriptionRequested);
    on<DeleteSubscriptionRequested>(_onDeleteSubscriptionRequested);
    on<DetectSubscriptionsRequested>(_onDetectSubscriptionsRequested);
  }

  Future<void> _onGetSubscriptionsRequested(
    GetSubscriptionsRequested event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(state.copyWith(status: SubscriptionStatus.loading));
    final result = await _repository.getSubscriptions();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SubscriptionStatus.failure,
          errorMessage: failure.toString(),
        ),
      ),
      (subscriptions) => emit(
        state.copyWith(
          status: SubscriptionStatus.success,
          subscriptions: subscriptions,
        ),
      ),
    );
  }

  Future<void> _onAddSubscriptionRequested(
    AddSubscriptionRequested event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(state.copyWith(status: SubscriptionStatus.loading));
    final result = await _repository.addSubscription(event.subscription);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SubscriptionStatus.failure,
          errorMessage: failure.toString(),
        ),
      ),
      (_) => add(GetSubscriptionsRequested()),
    );
  }

  Future<void> _onUpdateSubscriptionRequested(
    UpdateSubscriptionRequested event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(state.copyWith(status: SubscriptionStatus.loading));
    final result = await _repository.updateSubscription(
      event.id,
      event.subscription,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SubscriptionStatus.failure,
          errorMessage: failure.toString(),
        ),
      ),
      (_) => add(GetSubscriptionsRequested()),
    );
  }

  Future<void> _onDeleteSubscriptionRequested(
    DeleteSubscriptionRequested event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(state.copyWith(status: SubscriptionStatus.loading));
    final result = await _repository.deleteSubscription(event.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SubscriptionStatus.failure,
          errorMessage: failure.toString(),
        ),
      ),
      (_) => add(GetSubscriptionsRequested()),
    );
  }

  Future<void> _onDetectSubscriptionsRequested(
    DetectSubscriptionsRequested event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(state.copyWith(status: SubscriptionStatus.loading));
    final result = await _repository.detectSubscriptions();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SubscriptionStatus.failure,
          errorMessage: failure.toString(),
        ),
      ),
      (suggestions) => emit(
        state.copyWith(
          status: SubscriptionStatus.success,
          suggestions: suggestions,
        ),
      ),
    );
  }
}
