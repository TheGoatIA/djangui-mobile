import 'package:equatable/equatable.dart';
import '../../domain/entities/tontine_entities.dart';

enum TontineStatus { initial, loading, success, error }

class TontineState extends Equatable {
  final TontineStatus status;
  final List<Tontine> tontines;
  final Tontine? selectedTontine;
  final List<TontineMember> selectedTontineMembers;
  final List<TontineContribution> selectedTontineContributions;
  final List<TontineMessage> selectedTontineMessages;
  final String? errorMessage;

  const TontineState({
    this.status = TontineStatus.initial,
    this.tontines = const [],
    this.selectedTontine,
    this.selectedTontineMembers = const [],
    this.selectedTontineContributions = const [],
    this.selectedTontineMessages = const [],
    this.errorMessage,
  });

  TontineState copyWith({
    TontineStatus? status,
    List<Tontine>? tontines,
    Tontine? selectedTontine,
    List<TontineMember>? selectedTontineMembers,
    List<TontineContribution>? selectedTontineContributions,
    List<TontineMessage>? selectedTontineMessages,
    String? errorMessage,
  }) {
    return TontineState(
      status: status ?? this.status,
      tontines: tontines ?? this.tontines,
      selectedTontine: selectedTontine ?? this.selectedTontine,
      selectedTontineMembers:
          selectedTontineMembers ?? this.selectedTontineMembers,
      selectedTontineContributions:
          selectedTontineContributions ?? this.selectedTontineContributions,
      selectedTontineMessages:
          selectedTontineMessages ?? this.selectedTontineMessages,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    tontines,
    selectedTontine,
    selectedTontineMembers,
    selectedTontineContributions,
    selectedTontineMessages,
    errorMessage,
  ];
}
