import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/services/domain/usecases/internal_create_service_usecase.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/create/service_create_state.dart';

class ServiceCreateCubit extends Cubit<ServiceCreateState> {
  final InternalCreateServiceUsecase _createServiceUsecase;

  ServiceCreateCubit(this._createServiceUsecase)
      : super(const ServiceCreateState(status: ServiceCreateStatus.initial));

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
    final configs = state.serviceConfig.workOrderConfigs;
    if (index < 0 || index >= configs.length) return;

    final updated = List<ServiceWorkOrderConfigDraft>.from(configs);

    updated[index] = updated[index].copyWith(departmentOnDuty: value);

    emit(
      state.copyWith(
        serviceConfig: state.serviceConfig.copyWith(workOrderConfigs: updated),
      ),
    );
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
  Future<void> submit() async {
    emit(state.copyWith(status: ServiceCreateStatus.loading));

    try {
      final entity = state.serviceConfig.toEntity(id: "");

      await _createServiceUsecase(entity);

      emit(state.copyWith(status: ServiceCreateStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: ServiceCreateStatus.error,
        errorMessage: "Invalid Data in Service Config",
      ));
    }
  }
}
