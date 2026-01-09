import 'package:equatable/equatable.dart';

abstract class SystemEvent extends Equatable {
  const SystemEvent();

  @override
  List<Object?> get props => [];
}

class GetPublicSettingsRequested extends SystemEvent {}
