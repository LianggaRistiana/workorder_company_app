import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/provider_integration_data_entity.dart';
import 'package:workorder_company_app/features/system_integration/domain/usecases/get_provider_integration_usecase.dart';
import 'package:workorder_company_app/features/system_integration/domain/usecases/update_provider_integration_usecase.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/system_integration_config.dart/system_integration_config_state.dart';

class SystemIntegrationConfigCubit extends Cubit<SystemIntegrationConfigState> {
  final GetProviderIntegrationUsecase _getProviderIntegrationUsecase;
  final UpdateProviderIntegrationUsecase _updateProviderIntegrationUsecase;

  SystemIntegrationConfigCubit(
    this._getProviderIntegrationUsecase,
    this._updateProviderIntegrationUsecase,
  ) : super(const SystemIntegrationConfigState());

  Future<void> loadProviderIntegrationData() async {
    emit(state.copyWith(status: SystemIntegrationConfigStateStatus.loading));

    final result = await _getProviderIntegrationUsecase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: SystemIntegrationConfigStateStatus.loadError,
        errorMessage: failure.message,
      )),
      (data) => emit(state.copyWith(
        status: SystemIntegrationConfigStateStatus.loaded,
        providerIntegrationData: data,
      )),
    );
  }

  Future<void> updateProviderIntegrationData(
    ProviderIntegrationDataEntity providerIntegrationData,
  ) async {
    emit(state.copyWith(
        status: SystemIntegrationConfigStateStatus.updateLoading));

    final result =
        await _updateProviderIntegrationUsecase(providerIntegrationData);

    result.fold(
      (failure) => emit(state.copyWith(
        status: SystemIntegrationConfigStateStatus.updateError,
        errorMessage: failure.message,
      )),
      (data) => emit(state.copyWith(
        status: SystemIntegrationConfigStateStatus.updateSuccess,
        providerIntegrationData: data,
      )),
    );
  }
}
