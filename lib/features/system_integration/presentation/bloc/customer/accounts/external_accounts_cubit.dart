import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/system_integration/domain/usecases/detach_account_usecase.dart';
import 'package:workorder_company_app/features/system_integration/domain/usecases/get_all_paired_account_usecase.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/customer/accounts/external_accounts_state.dart';

class ExternalAccountsCubit extends Cubit<ExternalAccountsState> {
  final GetAllPairedAccountUsecase _getExternalAccountsUsecase;
  final DetachAccountUsecase _detachAccountUsecase;

  String? detachingAccountId;

  ExternalAccountsCubit(
      this._getExternalAccountsUsecase, this._detachAccountUsecase)
      : super(ExternalAccountsState.initial());

  Future<void> loadAccounts() async {
    emit(state.copyWith(status: ExternalAccountsStateStatus.loading));

    final result = await _getExternalAccountsUsecase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: ExternalAccountsStateStatus.loadError,
        errorMessage: failure.message,
      )),
      (accounts) => emit(state.copyWith(
        status: ExternalAccountsStateStatus.loaded,
        accounts: accounts,
      )),
    );
  }

  Future<void> detachAccount(String connectionId) async {
    if (state.status == ExternalAccountsStateStatus.detachLoading) {
      return;
    }

    emit(state.copyWith(
      status: ExternalAccountsStateStatus.detachLoading,
    ));
    detachingAccountId = connectionId;
    final result = await _detachAccountUsecase(connectionId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ExternalAccountsStateStatus.detachError,
        errorMessage: failure.message,
      )),
      (data) => _removeAccount(connectionId),
    );
  }

  void _removeAccount(String connectionId) {
    final updatedAccounts =
        state.accounts.where((acc) => acc.id != connectionId).toList();
    emit(state.copyWith(
      accounts: updatedAccounts,
      status: ExternalAccountsStateStatus.detachSuccess,
    ));
  }
}
