import 'package:workorder_company_app/features/system_integration/domain/entities/external_user_entity.dart';

enum ExternalAccountsStateStatus {
  initial,
  loading,
  loaded,
  loadError,
  detachLoading,
  detachSuccess,
  detachError
}

class ExternalAccountsState {
  final ExternalAccountsStateStatus status;
  final List<ExternalUserEntity> accounts;
  final String? errorMessage;

  bool get hasAnyError =>
      status == ExternalAccountsStateStatus.loadError ||
      status == ExternalAccountsStateStatus.detachError;

  bool get loading => status == ExternalAccountsStateStatus.loading;

  const ExternalAccountsState({
    required this.status,
    this.accounts = const [],
    this.errorMessage,
  });

  factory ExternalAccountsState.initial() => const ExternalAccountsState(
        status: ExternalAccountsStateStatus.initial,
      );

  ExternalAccountsState copyWith({
    ExternalAccountsStateStatus? status,
    List<ExternalUserEntity>? accounts,
    String? errorMessage,
  }) {
    return ExternalAccountsState(
      status: status ?? this.status,
      accounts: accounts ?? this.accounts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
