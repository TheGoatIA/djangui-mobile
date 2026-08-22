import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:kauri/core/services/log_service.dart';
import 'package:kauri/di/injection.dart';
import '../../data/models/subscription_model.dart';
import '../../domain/repositories/subscription_repository.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

@injectable
class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionRepository _repository;
  LogService get _logger => getIt<LogService>();

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
    _logger.info(
      'Récupération de la liste des abonnements...',
      component: 'SubscriptionBloc',
    );
    emit(state.copyWith(status: SubscriptionStatus.loading));
    final result = await _repository.getSubscriptions();
    result.fold(
      (failure) {
        _logger.error(
          'Échec de la récupération des abonnements',
          error: failure.toString(),
          component: 'SubscriptionBloc',
        );
        emit(
          state.copyWith(
            status: SubscriptionStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (subscriptions) {
        _logger.info(
          '${subscriptions.length} abonnements récupérés.',
          component: 'SubscriptionBloc',
        );
        emit(
          state.copyWith(
            status: SubscriptionStatus.success,
            subscriptions: subscriptions,
          ),
        );
      },
    );
  }

  Future<void> _onAddSubscriptionRequested(
    AddSubscriptionRequested event,
    Emitter<SubscriptionState> emit,
  ) async {
    _logger.info(
      'Tentative d\'ajout d\'un abonnement...',
      component: 'SubscriptionBloc',
      metadata: {'name': event.subscription.name},
    );
    emit(state.copyWith(status: SubscriptionStatus.loading));
    final result = await _repository.addSubscription(event.subscription);
    result.fold(
      (failure) {
        _logger.error(
          'Échec de l\'ajout de l\'abonnement',
          error: failure.toString(),
          component: 'SubscriptionBloc',
        );
        emit(
          state.copyWith(
            status: SubscriptionStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        _logger.info(
          'Abonnement ajouté avec succès.',
          component: 'SubscriptionBloc',
        );
        add(GetSubscriptionsRequested());
      },
    );
  }

  Future<void> _onUpdateSubscriptionRequested(
    UpdateSubscriptionRequested event,
    Emitter<SubscriptionState> emit,
  ) async {
    _logger.info(
      'Mise à jour de l\'abonnement: ${event.id}',
      component: 'SubscriptionBloc',
    );
    emit(state.copyWith(status: SubscriptionStatus.loading));
    final result = await _repository.updateSubscription(
      event.id,
      event.subscription,
    );
    result.fold(
      (failure) {
        _logger.error(
          'Échec de la mise à jour de l\'abonnement',
          error: failure.toString(),
          component: 'SubscriptionBloc',
        );
        emit(
          state.copyWith(
            status: SubscriptionStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        _logger.info(
          'Abonnement mis à jour avec succès.',
          component: 'SubscriptionBloc',
        );
        add(GetSubscriptionsRequested());
      },
    );
  }

  Future<void> _onDeleteSubscriptionRequested(
    DeleteSubscriptionRequested event,
    Emitter<SubscriptionState> emit,
  ) async {
    _logger.info(
      'Suppression de l\'abonnement: ${event.id}',
      component: 'SubscriptionBloc',
    );
    emit(state.copyWith(status: SubscriptionStatus.loading));
    final result = await _repository.deleteSubscription(event.id);
    result.fold(
      (failure) {
        _logger.error(
          'Échec de la suppression de l\'abonnement',
          error: failure.toString(),
          component: 'SubscriptionBloc',
        );
        emit(
          state.copyWith(
            status: SubscriptionStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        _logger.info(
          'Abonnement supprimé avec succès.',
          component: 'SubscriptionBloc',
        );
        add(GetSubscriptionsRequested());
      },
    );
  }

  Future<void> _onDetectSubscriptionsRequested(
    DetectSubscriptionsRequested event,
    Emitter<SubscriptionState> emit,
  ) async {
    _logger.info(
      'Détection automatique des abonnements...',
      component: 'SubscriptionBloc',
    );
    emit(state.copyWith(status: SubscriptionStatus.loading));
    final result = await _repository.detectSubscriptions();
    result.fold(
      (failure) {
        _logger.error(
          'Échec de la détection des abonnements',
          error: failure.toString(),
          component: 'SubscriptionBloc',
        );
        emit(
          state.copyWith(
            status: SubscriptionStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (suggestions) {
        _logger.info(
          '${suggestions.length} suggestions d\'abonnements détectées.',
          component: 'SubscriptionBloc',
        );
        emit(
          state.copyWith(
            status: SubscriptionStatus.success,
            suggestions: suggestions,
          ),
        );
      },
    );
  }
}
