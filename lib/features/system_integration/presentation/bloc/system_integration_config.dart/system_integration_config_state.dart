import 'package:workorder_company_app/features/system_integration/domain/entities/provider_integration_data_entity.dart';

enum SystemIntegrationConfigStateStatus {
  initial,
  loading,
  loaded,
  loadError,
  updateError,
  updateSuccess,
  updateLoading,
}

class SystemIntegrationConfigState {
  final SystemIntegrationConfigStateStatus status;
  final ProviderIntegrationDataEntity? providerIntegrationData;
  final String? errorMessage;

  bool get isUpdateLoading =>
      status == SystemIntegrationConfigStateStatus.updateLoading;
  bool get hasAnyError =>
      status == SystemIntegrationConfigStateStatus.loadError ||
      status == SystemIntegrationConfigStateStatus.updateError;

  const SystemIntegrationConfigState({
    this.status = SystemIntegrationConfigStateStatus.initial,
    this.providerIntegrationData,
    this.errorMessage,
  });

  SystemIntegrationConfigState copyWith({
    SystemIntegrationConfigStateStatus? status,
    ProviderIntegrationDataEntity? providerIntegrationData,
    String? errorMessage,
  }) {
    return SystemIntegrationConfigState(
      status: status ?? this.status,
      providerIntegrationData:
          providerIntegrationData ?? this.providerIntegrationData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
