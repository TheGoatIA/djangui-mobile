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
  // Passive "fetching this tontine's details/members to display it" flag —
  // deliberately separate from [status], which is reserved for explicit user
  // actions (start/rotate/validate/pay/update/delete/...). Mixing the two
  // made simply opening (or re-opening) a tontine look like an action just
  // completed, popping up an unrelated "opération réalisée avec succès" toast.
  final bool isLoadingDetails;
  // Same idea as [isLoadingDetails], for the chat's message list — lets the
  // UI show a spinner only on a genuine first load (nothing cached yet),
  // without it being confused for an action's loading dialog.
  final bool isLoadingMessages;

  /// Incrémenté à chaque cotisation ENVOYÉE avec succès (signal ponctuel pour
  /// afficher la confirmation — il n'y en avait aucune).
  final int contributionsSent;

  const TontineState({
    this.status = TontineStatus.initial,
    this.tontines = const [],
    this.selectedTontine,
    this.selectedTontineMembers = const [],
    this.selectedTontineContributions = const [],
    this.selectedTontineMessages = const [],
    this.errorMessage,
    this.isLoadingDetails = false,
    this.isLoadingMessages = false,
    this.contributionsSent = 0,
  });

  TontineState copyWith({
    TontineStatus? status,
    List<Tontine>? tontines,
    Tontine? selectedTontine,
    List<TontineMember>? selectedTontineMembers,
    List<TontineContribution>? selectedTontineContributions,
    List<TontineMessage>? selectedTontineMessages,
    String? errorMessage,
    bool? isLoadingDetails,
    bool? isLoadingMessages,
    int? contributionsSent,
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
      // Deliberately NOT `errorMessage ?? this.errorMessage`: an error is a
      // one-shot signal for whichever action just failed. Falling back to the
      // previous value made a stale error re-surface on every later emit that
      // didn't bother to explicitly re-state it — including successful ones —
      // so a transient failure from minutes ago could pop back up attached to
      // an unrelated, successful state change.
      errorMessage: errorMessage,
      isLoadingDetails: isLoadingDetails ?? this.isLoadingDetails,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      contributionsSent: contributionsSent ?? this.contributionsSent,
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
    isLoadingDetails,
    isLoadingMessages,
    contributionsSent,
  ];
}
