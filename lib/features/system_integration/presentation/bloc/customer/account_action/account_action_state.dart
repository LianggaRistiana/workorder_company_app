import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/external_user_entity.dart';

enum AccountActionStateStatus {
  initial,
  loading,
  loaded,
  loadError,
  detachLoading,
  detachSuccess,
  detachError,
}

class AccountActionState extends Equatable {
  final AccountActionStateStatus status;
  final String? errorMessage;
  final ExternalUserEntity? externalAccount;

  bool get isLoading => status == AccountActionStateStatus.loading;
  bool get isLoaded => status == AccountActionStateStatus.loaded;

  bool get isDetachLoading => status == AccountActionStateStatus.detachLoading;
  bool get isDetachSuccess => status == AccountActionStateStatus.detachSuccess;

  const AccountActionState({
    required this.status,
    this.externalAccount,
    this.errorMessage,
  });

  factory AccountActionState.initial() {
    return const AccountActionState(status: AccountActionStateStatus.initial);
  }

  AccountActionState copyWith({
    AccountActionStateStatus? status,
    ExternalUserEntity? externalAccount,
    String? errorMessage,
  }) {
    return AccountActionState(
      status: status ?? this.status,
      externalAccount: externalAccount ?? this.externalAccount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        externalAccount,
        errorMessage,
      ];
}
