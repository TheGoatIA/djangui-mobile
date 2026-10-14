import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/investment_model.dart';
import '../../domain/repositories/investment_repository.dart';

part 'investments_event.dart';
part 'investments_state.dart';

@lazySingleton
class InvestmentsBloc extends Bloc<InvestmentsEvent, InvestmentsState> {
  final InvestmentRepository _repository;

  InvestmentsBloc(this._repository) : super(InvestmentsState.initial()) {
    on<LoadInvestments>(_onLoadInvestments);
    on<AddInvestment>(_onAddInvestment);
    on<DeleteInvestment>(_onDeleteInvestment);
  }

  Future<void> _onLoadInvestments(
    LoadInvestments event,
    Emitter<InvestmentsState> emit,
  ) async {
    emit(state.copyWith(status: InvestmentsStatus.loading));
    final result = await _repository.getInvestments();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: InvestmentsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (investments) => emit(
        state.copyWith(
          status: InvestmentsStatus.loaded,
          investments: investments,
        ),
      ),
    );
  }

  Future<void> _onAddInvestment(
    AddInvestment event,
    Emitter<InvestmentsState> emit,
  ) async {
    // Optimistic update or wait? Let's just create side-effect then reload or add to list.
    // For simplicity, just reload for now, or append to list if backend response confirms.
    // Adding logic:
    final result = await _repository.addInvestment(event.investment);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: InvestmentsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        add(const LoadInvestments());
      },
    );
  }

  Future<void> _onDeleteInvestment(
    DeleteInvestment event,
    Emitter<InvestmentsState> emit,
  ) async {
    final result = await _repository.deleteInvestment(event.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: InvestmentsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        add(const LoadInvestments());
      },
    );
  }
}
