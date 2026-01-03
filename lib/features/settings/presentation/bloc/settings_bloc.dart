import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_event.dart';
part 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SharedPreferences _prefs;

  SettingsBloc(this._prefs) : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<ThemeChanged>(_onThemeChanged);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) {
    final themeIndex = _prefs.getInt('theme_mode');
    if (themeIndex != null) {
      emit(state.copyWith(themeMode: ThemeMode.values[themeIndex]));
    }
  }

  Future<void> _onThemeChanged(
    ThemeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    await _prefs.setInt('theme_mode', event.themeMode.index);
    emit(state.copyWith(themeMode: event.themeMode));
  }
}
