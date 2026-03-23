import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
// import 'package:workorder_company_app/features/services/domain/entities/service_work_order_config.dart';
import 'package:workorder_company_app/features/services_legacy/presentation/bloc/service_config_state.dart';
import 'package:workorder_company_app/features/services_legacy/domain/usecases/create_service_usecase.dart';

// TODO : Use this to add service
class AddServiceCubit extends Cubit<ServiceConfigState> {
  // ignore: unused_field
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

  void updateDescription(String value) {
    emit(
      state.copyWith(
        serviceConfig: state.serviceConfig.copyWith(description: value),
      ),
    );
  }

  void addDepartment(PositionEntity department) {
    final updatedDepartments = List<PositionEntity>.from(
      state.serviceConfig.departments,
    );
    updatedDepartments.add(department);
    emit(
      state.copyWith(
        serviceConfig: state.serviceConfig.copyWith(
          departments: updatedDepartments,
        ),
      ),
    );
  }

  void removeDepartment(PositionEntity department) {
    final updatedDepartments = List<PositionEntity>.from(
      state.serviceConfig.departments,
    );
    updatedDepartments.removeWhere((d) => d.id == department.id);

    emit(state.copyWith(
      serviceConfig: state.serviceConfig.copyWith(
        departments: updatedDepartments,
      ),
    ));
  }

  void updateAccessType(ServiceAccessType type) {
    // Logger().d(type);
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

  void updateServiceRequestApprovalAccess(ServiceRequestApprovalAccess value) {
    emit(state.copyWith(
      serviceConfig: state.serviceConfig.copyWith(
        serviceRequestApprovalAccess: value,
      ),
    ));
  }

  void updateIntakeForm(FormEntity form) {
    emit(state.copyWith(
      serviceConfig: state.serviceConfig.copyWith(intakeForm: form),
    ));
  }

  void updateReviewForm(FormEntity form) {
    emit(state.copyWith(
      serviceConfig: state.serviceConfig.copyWith(reviewForm: form),
    ));
  }

  void addWorkOrder(FormEntity form) {
    final updatedWorkOrderConfigs = List<ServiceWorkOrderConfigDraft>.from(
      state.serviceConfig.workOrderConfigs,
    );
    updatedWorkOrderConfigs
        .add(ServiceWorkOrderConfigDraft(workOrderForm: form));
    emit(state.copyWith(
      serviceConfig: state.serviceConfig
          .copyWith(workOrderConfigs: updatedWorkOrderConfigs),
    ));
  }

  void updateWorkOrderApprovalAccess(
    WorkOrderAprrovalAccess value,
    int index,
  ) {
    final configs = state.serviceConfig.workOrderConfigs;

    if (index < 0 || index >= configs.length) return;

    final updatedConfigs = List<ServiceWorkOrderConfigDraft>.from(configs);

    updatedConfigs[index] =
        updatedConfigs[index].copyWith(workOrderApprovalAccess: value);

    emit(
      state.copyWith(
        serviceConfig: state.serviceConfig.copyWith(
          workOrderConfigs: updatedConfigs,
        ),
      ),
    );
  }

  void updateMinStaff(int? value, int index) {
    Logger().d(value);
    final configs = state.serviceConfig.workOrderConfigs;
    if (index < 0 || index >= configs.length) return;

    final updated = List<ServiceWorkOrderConfigDraft>.from(configs);

    updated[index] = updated[index].copyWith(minStaff: value);

    emit(
      state.copyWith(
        serviceConfig: state.serviceConfig.copyWith(workOrderConfigs: updated),
      ),
    );
  }

  void updateMaxStaff(int? value, int index) {
    Logger().d(value);
    final configs = state.serviceConfig.workOrderConfigs;
    if (index < 0 || index >= configs.length) return;

    final updated = List<ServiceWorkOrderConfigDraft>.from(configs);

    updated[index] = updated[index].copyWith(maxStaff: value);

    emit(
      state.copyWith(
        serviceConfig: state.serviceConfig.copyWith(workOrderConfigs: updated),
      ),
    );
  }

  void updateDepartmentOnDuty(PositionEntity? value, int index) {
    Logger().d(value);
    final configs = state.serviceConfig.workOrderConfigs;
    if (index < 0 || index >= configs.length) return;

    final updated = List<ServiceWorkOrderConfigDraft>.from(configs);

    updated[index] = updated[index].copyWith(departmentOnDuty: value);

    emit(
      state.copyWith(
        serviceConfig: state.serviceConfig.copyWith(workOrderConfigs: updated),
      ),
    );

    Logger().d(state.serviceConfig.workOrderConfigs);
  }

  void updateWorkReportApprovalAccess(
    WorkReportApprovalAccess value,
    int index,
  ) {
    final configs = state.serviceConfig.workOrderConfigs;
    if (index < 0 || index >= configs.length) return;

    final updated = List<ServiceWorkOrderConfigDraft>.from(configs);

    updated[index] = updated[index].copyWith(workReportApprovalAccess: value);

    emit(
      state.copyWith(
        serviceConfig: state.serviceConfig.copyWith(workOrderConfigs: updated),
      ),
    );
  }

  void removeServiceWorkOrderConfig(int index) {
    final configs = state.serviceConfig.workOrderConfigs;

    if (index < 0 || index >= configs.length) return;

    final updated = List<ServiceWorkOrderConfigDraft>.from(configs)
      ..removeAt(index);

    emit(
      state.copyWith(
        serviceConfig: state.serviceConfig.copyWith(workOrderConfigs: updated),
      ),
    );
  }

  void updateWorkReportForm(FormEntity form, int index) {
    final currentConfigs = state.serviceConfig.workOrderConfigs;

    if (index < 0 || index >= currentConfigs.length) return;

    final oldDraft = currentConfigs[index];

    // ⛔ Hindari emit kalau datanya sama (penting untuk mencegah rebuild tidak perlu)
    if (oldDraft.reportForm == form) return;

    final updatedDraft = oldDraft.copyWith(
      reportForm: form,
    );

    final updatedConfigs =
        List<ServiceWorkOrderConfigDraft>.from(currentConfigs)
          ..[index] = updatedDraft;

    emit(
      state.copyWith(
        serviceConfig: state.serviceConfig.copyWith(
          workOrderConfigs: updatedConfigs,
        ),
      ),
    );
  }

  // --- Submit service ---
  // Future<void> submit() async {
  //   emit(state.copyWith(isConfigLoading: true, errorMessage: null));

  //   final service = state.serviceConfig;

  //   final servicePayload = ServiceEntity(
  //     id: '',
  //     title: service.title,
  //     description: service.description,
  //     clientIntakeForms: service.selectedIntakeForms,
  //     workOrderForms: service.selectedWorkOrderForms,
  //     reportForms: service.selectedReportForms,
  //     accessType: service.accessType,
  //     isActive: service.isActive,
  //   );

  //   // 🔹 Jalankan usecase
  //   final result = await _createServiceUsecase(servicePayload);
  //   result.fold(
  //     (failure) => emit(
  //       state.copyWith(
  //         isConfigLoading: false,
  //         errorMessage: failure.message,
  //       ),
  //     ),
  //     (_) => emit(
  //       state.copyWith(
  //         isConfigLoading: false,
  //         isSubmitted: true,
  //       ),
  //     ),
  //   );
  // }

  // --- Reset form ---
  void reset() {
    emit(const ServiceConfigState(serviceConfig: ServiceConfig()));
  }
}
