import 'package:equatable/equatable.dart';

abstract class SystemEvent extends Equatable {
  const SystemEvent();

  @override
  List<Object?> get props => [];
}

class GetPublicSettingsRequested extends SystemEvent {
  const GetPublicSettingsRequested();
}

class GetCountriesRequested extends SystemEvent {
  const GetCountriesRequested();
}

class GetFeatureFlagsRequested extends SystemEvent {
  const GetFeatureFlagsRequested();
}

class InitializeSystem extends SystemEvent {
  const InitializeSystem();
}
