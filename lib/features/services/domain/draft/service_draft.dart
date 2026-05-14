import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/services/domain/draft/service_work_order_config_draft.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_request_config_entity.dart';

class ServiceDraft extends Equatable {
  final String id;
  final bool isActive;
  final String title;
  final String description;
  final ServiceAccessType accessType;

  final ServiceRequestApprovalAccess requestApprovalAccess;
  final FormEntity? intakeForm;
  final FormEntity? reviewForm;

  final WorkOrderDraftingType workOrderDraftingType;
  final List<ServiceWorkOrderConfigDraft> workOrders;
  final bool reviewNeed;

  const ServiceDraft({
    required this.id,
    required this.isActive,
    required this.title,
    required this.description,
    required this.accessType,
    required this.requestApprovalAccess,
    required this.intakeForm,
    required this.reviewForm,
    required this.workOrders,
    required this.reviewNeed,
    required this.workOrderDraftingType,
  });

  factory ServiceDraft.initial() {
    return const ServiceDraft(
      id: '',
      isActive: true,
      title: '',
      description: '',
      accessType: ServiceAccessType.internal,
      requestApprovalAccess: ServiceRequestApprovalAccess.manager,
      intakeForm: null,
      reviewForm: null,
      workOrderDraftingType: WorkOrderDraftingType.manual,
      workOrders: [],
      reviewNeed: true,
    );
  }

  factory ServiceDraft.fromEntity(ServiceEntity entity) {
    return ServiceDraft(
      id: entity.id,
      isActive: entity.isActive,
      title: entity.title,
      description: entity.description ?? '',
      accessType: entity.accessType,
      requestApprovalAccess:
          entity.serviceRequestConfig.serviceRequestApprovalAccessType,
      intakeForm: entity.serviceRequestConfig.intakeForm,
      reviewForm: entity.serviceRequestConfig.reviewForm,
      workOrderDraftingType: entity.workOrderDraftingType,
      workOrders: entity.workOrdersConfig
          .map((e) => ServiceWorkOrderConfigDraft.fromEntity(e))
          .toList(),
      reviewNeed: entity.serviceRequestConfig.reviewNeed,
    );
  }

  ServiceDraft copyWith({
    bool? isActive,
    String? title,
    String? description,
    ServiceAccessType? accessType,
    ServiceRequestApprovalAccess? requestApprovalAccess,
    FormEntity? intakeForm,
    FormEntity? reviewForm,
    List<ServiceWorkOrderConfigDraft>? workOrders,
    bool? reviewNeed,
    WorkOrderDraftingType? workOrderDraftingType,
  }) {
    return ServiceDraft(
      id: id,
      isActive: isActive ?? this.isActive,
      title: title ?? this.title,
      description: description ?? this.description,
      accessType: accessType ?? this.accessType,
      requestApprovalAccess:
          requestApprovalAccess ?? this.requestApprovalAccess,
      intakeForm: intakeForm ?? this.intakeForm,
      reviewForm: reviewForm ?? this.reviewForm,
      workOrders: workOrders ?? this.workOrders,
      reviewNeed: reviewNeed ?? this.reviewNeed,
      workOrderDraftingType:
          workOrderDraftingType ?? this.workOrderDraftingType,
    );
  }

  /// =========================
  /// WORK ORDER OPERATIONS
  /// =========================

  ServiceDraft addManualWorkOrder(
    FormEntity workOrderForm,
  ) {
    return _addWorkOrder(
      ServiceWorkOrderConfigDraft.manualDrafting(
        workOrderForm: workOrderForm,
      ),
    );
  }

  ServiceDraft addAutoWorkOrder() {
    return _addWorkOrder(
      ServiceWorkOrderConfigDraft.autoDrafting(),
    );
  }

  ServiceDraft addManualWorkOrderWithPosition(
    FormEntity workOrderForm,
    PositionEntity position,
  ) {
    return _addWorkOrder(
      ServiceWorkOrderConfigDraft.manualDrafting(
        workOrderForm: workOrderForm,
      ).withPosition(position),
    );
  }

  ServiceDraft addAutoWorkOrderWithPosition(
    PositionEntity position,
  ) {
    return _addWorkOrder(
      ServiceWorkOrderConfigDraft.autoDrafting().withPosition(position),
    );
  }

  ServiceDraft _addWorkOrder(
    ServiceWorkOrderConfigDraft draft,
  ) {
    return copyWith(
      workOrders: [
        ...workOrders,
        draft,
      ],
    );
  }

  ServiceDraft removeWorkOrder(int index) {
    final updated = [...workOrders]..removeAt(index);
    return copyWith(workOrders: updated);
  }

  ServiceDraft removeWorkOrderWithNullForm() {
    final updated = [...workOrders]
      ..removeWhere((element) => element.workOrderForm == null);
    return copyWith(workOrders: updated);
  }

  ServiceDraft updateDraftingType(
    WorkOrderDraftingType value,
  ) {
    ServiceDraft updatedDraft = copyWith();

    // if (value == WorkOrderDraftingType.manual) {
    //   updatedDraft = updatedDraft.removeWorkOrderWithNullForm();
    // }

    return updatedDraft.copyWith(
      workOrderDraftingType: value,
    );
  }

  ServiceDraft updateWorkOrder(
    int index,
    ServiceWorkOrderConfigDraft updatedDraft,
  ) {
    final updated = [...workOrders];
    updated[index] = updatedDraft;
    return copyWith(workOrders: updated);
  }

  ServiceDraft updateWorkOrderForm(int index, FormEntity form) {
    final target = workOrders[index];
    final updated = target.copyWith(workOrderForm: form);
    return updateWorkOrder(index, updated);
  }

  /// =========================
  /// FIELD UPDATE BY INDEX
  /// =========================

  ServiceDraft updateDepartment(
    int index,
    PositionEntity position,
  ) {
    final item = workOrders[index];

    return updateWorkOrder(
      index,
      item.copyWith(departmentOnDuty: position),
    );
  }

  ServiceDraft updateMinStaff(
    int index,
    int? value,
  ) {
    final item = workOrders[index];

    return updateWorkOrder(
      index,
      item.copyWith(minStaff: value),
    );
  }

  ServiceDraft updateMaxStaff(
    int index,
    int? value,
  ) {
    final item = workOrders[index];

    return updateWorkOrder(
      index,
      item.copyWith(maxStaff: value),
    );
  }

  ServiceDraft updateApproval(
    int index,
    WorkOrderAprrovalAccess value,
  ) {
    final item = workOrders[index];

    return updateWorkOrder(
      index,
      item.copyWith(workOrderApprovalAccess: value),
    );
  }

  /// =========================
  /// OPTIONAL HELPERS
  /// =========================

  ServiceDraft clearIntakeForm() {
    return copyWith(intakeForm: null);
  }

  ServiceDraft clearReviewForm() {
    return copyWith(reviewForm: null);
  }

  bool get hasAtLeastOneWorkOrder => workOrders.isNotEmpty;

  bool get allWorkOrderHasDepartment =>
      workOrders.every((e) => e.hasDepartment);

  bool get allWorkOrderHasValidStaff => workOrders.every((e) => e.isStaffValid);

  bool get allWorkOrderHasValidForm {
    if (isManualDrafting) {
      return isAllWorkOrderNotNull();
    }
    return true;
  }

  bool get isBasicInfoValid =>
      title.trim().isNotEmpty && description.trim().isNotEmpty;

  bool get isManualDrafting =>
      workOrderDraftingType == WorkOrderDraftingType.manual;

  bool get isAutoDrafting =>
      workOrderDraftingType == WorkOrderDraftingType.auto;

  bool isAllWorkOrderNotNull() {
    return workOrders.every((element) => element.workOrderForm != null);
  }

  @override
  List<Object?> get props => [
        id,
        isActive,
        title,
        description,
        accessType,
        requestApprovalAccess,
        workOrderDraftingType,
        intakeForm,
        reviewForm,
        workOrders,
        reviewNeed,
      ];
}

extension ServiceDraftMapper on ServiceDraft {
  ServiceEntity toEntity() {
    if (!isBasicInfoValid) {
      throw ValidationException("Informasi dasar layanan belum lengkap");
    }

    if (intakeForm == null) {
      throw ValidationException("Form intake wajib dipilih");
    }

    if (reviewForm == null) {
      throw ValidationException("Form review wajib dipilih");
    }

    if (workOrders.isEmpty) {
      throw ValidationException("Minimal 1 work order");
    }

    if (isManualDrafting && !isAllWorkOrderNotNull()) {
      throw ValidationException(
          "Layanan dengan mode penyusunan perintah kerja manual wajib memiliki form perintah kerja");
    }

    return ServiceEntity(
      id: id,
      title: title.trim(),
      description: description.trim(),
      accessType: accessType,
      isActive: isActive,
      workOrderDraftingType: workOrderDraftingType,
      serviceRequestConfig: ServiceRequestConfigEntity(
        intakeForm: intakeForm!,
        reviewForm: reviewForm!,
        serviceRequestApprovalAccessType: isAutoDrafting
            ? ServiceRequestApprovalAccess.auto
            : requestApprovalAccess,
        reviewNeed: reviewNeed,
      ),
      workOrdersConfig:
          workOrders.map((e) => e.toEntity(workOrderDraftingType)).toList(),
    );
  }
}
