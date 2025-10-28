import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/ordered_form_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/service_config_state.dart';
import 'package:workorder_company_app/features/services/domain/usecases/create_service_usecase.dart';


// TODO : Use this to add service
class AddServiceCubit extends Cubit<ServiceConfigState> {
  final CreateServiceUsecase _createServiceUsecase;

  AddServiceCubit(this._createServiceUsecase)
      : super(const ServiceConfigState(serviceConfig: ServiceConfig()));

  // --- Update field form ---

  void updateTitle(String value) {
    emit(
      state.copyWith(
        serviceConfig: state.serviceConfig.copyWith(title: value),
      ),
    );
  }
  

  void addIntakeForm(FormEntity form) {
    final updatedForms = List<OrderedFormEntity>.from(
      state.serviceConfig.selectedIntakeForms,
    );
    updatedForms.add(
      OrderedFormEntity(
        order: updatedForms.length + 1,
        form: form,
      ),
    );
    emit(
      state.copyWith(
        serviceConfig: state.serviceConfig.copyWith(
          selectedIntakeForms: updatedForms,
        ),
      ),
    );
    
  }

  void removeIntakeForm(FormEntity form) {
    final updatedForms = List<OrderedFormEntity>.from(
      state.serviceConfig.selectedIntakeForms,
    );
    updatedForms.removeWhere((f) => f.form.id == form.id);

    for (var i = 0; i < updatedForms.length; i++) {
      updatedForms[i] = updatedForms[i].copyWith(order: i + 1);
    }

    emit(
      state.copyWith(
        serviceConfig: state.serviceConfig.copyWith(
          selectedIntakeForms: updatedForms,
        ),
      ),
    );
  }
  
  void updateSelectedIntakeForms(List<OrderedFormEntity> value) {
    emit(
      state.copyWith(
        serviceConfig: state.serviceConfig.copyWith(
          selectedIntakeForms: value,
        ),
      ),
    );
  }



  void updateDescription(String value) {
    emit(
      state.copyWith(
        serviceConfig: state.serviceConfig.copyWith(description: value),
      ),
    );
  }

  void updateAccessType(ServiceAccessType type) {
    emit(
      state.copyWith(
        serviceConfig: state.serviceConfig.copyWith(accessType: type),
      ),
    );
  }

  void toggleActive(bool value) {
    emit(
      state.copyWith(
        serviceConfig: state.serviceConfig.copyWith(isActive: value),
      ),
    );
  }

  

  // --- Submit service ---
  Future<void> submit() async {
    emit(state.copyWith(isConfigLoading: true, errorMessage: null));

    final service = state.serviceConfig;

    final servicePayload = ServiceEntity(
      id: '',
      title: service.title,
      description: service.description,
      requiredStaff: service.requiredStaff,
      clientIntakeForms: service.selectedIntakeForms,
      workOrderForms: service.selectedWorkOrderForms,
      reportForms: service.selectedReportForms,
      accessType: service.accessType,
      isActive: service.isActive,
    );

    // 🔹 Jalankan usecase
    final result = await _createServiceUsecase(servicePayload);
    result.fold(
      (failure) => emit(
        state.copyWith(
          isConfigLoading: false,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          isConfigLoading: false,
          isSubmitted: true,
        ),
      ),
    );
  }

  // --- Reset form ---
  void reset() {
    emit(const ServiceConfigState(serviceConfig: ServiceConfig()));
  }
}
