import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kauri/core/utils/app_l10n.dart';
import 'package:kauri/core/error/error_mapper.dart';
import '../../domain/repositories/reseller_repository.dart';
import 'reseller_event.dart';
import 'reseller_state.dart';

class ResellerBloc extends Bloc<ResellerEvent, ResellerState> {
  final ResellerRepository _repository;

  ResellerBloc(this._repository) : super(ResellerInitial()) {
    on<FetchResellerDashboardRequested>((event, emit) async {
      emit(ResellerLoading());
      try {
        final stats = await _repository.getDashboardStats();
        final accounts = await _repository.getAccounts();
        emit(ResellerLoaded(stats: stats, accounts: accounts));
      } catch (e) {
        emit(ResellerError(ErrorMapper.safeMessage(e)));
      }
    });

    on<CreateMasterAccountRequested>((event, emit) async {
      emit(ResellerLoading());
      try {
        await _repository.createAccount(event.accountData);
        emit(ResellerActionSuccess(appL10n().resellerMasterCreated));
        add(FetchResellerDashboardRequested());
      } catch (e) {
        emit(ResellerError(ErrorMapper.safeMessage(e)));
      }
    });

    on<AddSlotToAccountRequested>((event, emit) async {
      emit(ResellerLoading());
      try {
        await _repository.addSlot(event.accountId, event.slotData);
        emit(ResellerActionSuccess(appL10n().resellerSlotAssigned));
        add(FetchResellerDashboardRequested());
      } catch (e) {
        emit(ResellerError(ErrorMapper.safeMessage(e)));
      }
    });

    on<RecordSlotPaymentRequested>((event, emit) async {
      emit(ResellerLoading());
      try {
        await _repository.recordPayment(event.slotId, event.paymentData);
        emit(ResellerActionSuccess(appL10n().paymentRecordedSuccess));
        add(FetchResellerDashboardRequested());
      } catch (e) {
        emit(ResellerError(ErrorMapper.safeMessage(e)));
      }
    });

    on<DeleteSlotRequested>((event, emit) async {
      emit(ResellerLoading());
      try {
        await _repository.deleteSlot(event.slotId);
        emit(ResellerActionSuccess(appL10n().resellerProfileFreed));
        add(FetchResellerDashboardRequested());
      } catch (e) {
        emit(ResellerError(ErrorMapper.safeMessage(e)));
      }
    });

    on<DeleteMasterAccountRequested>((event, emit) async {
      emit(ResellerLoading());
      try {
        await _repository.deleteAccount(event.accountId);
        emit(ResellerActionSuccess(appL10n().accountDeletedSuccess));
        add(FetchResellerDashboardRequested());
      } catch (e) {
        emit(ResellerError(ErrorMapper.safeMessage(e)));
      }
    });

    on<UnlockVaultRequested>((event, emit) async {
      emit(ResellerLoading());
      try {
        final vault = await _repository.unlockVault(event.accountId);
        emit(
          ResellerVaultUnlocked(
            email: vault['email'] ?? '',
            password: vault['password'] ?? '',
            pin: vault['pin'] ?? '',
            recoveryContact: vault['recoveryContact'] ?? '',
            secretNotes: vault['secretNotes'] ?? '',
          ),
        );
      } catch (e) {
        emit(ResellerError(ErrorMapper.safeMessage(e)));
      }
    });
  }
}
