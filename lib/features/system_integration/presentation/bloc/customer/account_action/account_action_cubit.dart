import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/external_user_entity.dart';
import 'package:workorder_company_app/features/system_integration/domain/usecases/detach_account_usecase.dart';
import 'package:workorder_company_app/features/system_integration/domain/usecases/get_account_pairing_usecase.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/customer/account_action/account_action_state.dart';

class AccountActionCubit extends Cubit<AccountActionState> {
  final GetAccountPairingUsecase _getAccountPairingUsecase;
  final DetachAccountUsecase _detachAccountUsecase;

  AccountActionCubit(
    this._getAccountPairingUsecase,
    this._detachAccountUsecase,
  ) : super(AccountActionState.initial());

  Future<void> getAccountPairingStatus(String companyId) async {
    emit(const AccountActionState(status: AccountActionStateStatus.loading));

    final result = await _getAccountPairingUsecase(companyId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: AccountActionStateStatus.loadError,
        errorMessage: failure.message,
      )),
      (data) => emit(state.copyWith(
        status: AccountActionStateStatus.loaded,
        externalAccount: data,
      )),
    );
  }

  Future<void> detachAccount(String companyId) async {
    emit(state.copyWith(
      status: AccountActionStateStatus.detachLoading,
    ));

    final result = await _detachAccountUsecase(companyId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: AccountActionStateStatus.detachError,
        errorMessage: failure.message,
      )),
      (data) => emit(AccountActionState(
        status: AccountActionStateStatus.detachSuccess,
      )),
    );
  }

  void replaceExternalAccount(ExternalUserEntity account) {
    emit(state.copyWith(externalAccount: account));
  }
}
