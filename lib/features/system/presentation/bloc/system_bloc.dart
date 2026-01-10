import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/system_repository.dart';
import 'system_event.dart';
import 'system_state.dart';

export 'system_event.dart';
export 'system_state.dart';

@injectable
class SystemBloc extends Bloc<SystemEvent, SystemState> {
  final SystemRepository _repository;

  SystemBloc(this._repository) : super(const SystemState()) {
    on<GetPublicSettingsRequested>(_onGetPublicSettingsRequested);
    on<GetCountriesRequested>(_onGetCountriesRequested);
  }

  Future<void> _onGetPublicSettingsRequested(
    GetPublicSettingsRequested event,
    Emitter<SystemState> emit,
  ) async {
    emit(state.copyWith(status: SystemStatus.loading));
    try {
      final settings = await _repository.getPublicSettings();
      emit(state.copyWith(status: SystemStatus.success, settings: settings));
    } catch (e) {
      emit(
        state.copyWith(
          status: SystemStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onGetCountriesRequested(
    GetCountriesRequested event,
    Emitter<SystemState> emit,
  ) async {
    emit(state.copyWith(status: SystemStatus.loading));
    try {
      final countries = await _repository.getCountries();
      emit(state.copyWith(status: SystemStatus.success, countries: countries));
    } catch (e) {
      emit(
        state.copyWith(
          status: SystemStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
