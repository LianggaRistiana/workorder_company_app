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

  final List<ServiceWorkOrderConfigDraft> workOrders;

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
      workOrders: [],
    );
  }

  factory ServiceDraft.fromEntity(ServiceEntity entity) {
    return ServiceDraft(
      id: entity.id,
      isActive: entity.isActive,
      title: entity.title,
      description: entity.description,
      accessType: entity.accessType,
      requestApprovalAccess:
          entity.serviceRequestConfig.serviceRequestApprovalAccessType,
      intakeForm: entity.serviceRequestConfig.intakeForm,
      reviewForm: entity.serviceRequestConfig.reviewForm,
      workOrders: entity.workOrdersConfig
          .map((e) => ServiceWorkOrderConfigDraft.fromEntity(e))
          .toList(),
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
    );
  }

  /// =========================
  /// WORK ORDER OPERATIONS
  /// =========================

  ServiceDraft addWorkOrder(FormEntity workOrderForm) {
    return copyWith(
      workOrders: [
        ...workOrders,
        ServiceWorkOrderConfigDraft.initial(workOrderForm: workOrderForm)
      ],
    );
  }

  // ServiceDraft addEmptyWorkOrder() {
  //   return copyWith(
  //     workOrders: [
  //       ...workOrders,
  //       ServiceWorkOrderConfigDraft.initial(),
  //     ],
  //   );
  // }

  ServiceDraft removeWorkOrder(int index) {
    final updated = [...workOrders]..removeAt(index);
    return copyWith(workOrders: updated);
  }

  ServiceDraft updateWorkOrder(
    int index,
    ServiceWorkOrderConfigDraft updatedDraft,
  ) {
    final updated = [...workOrders];
    updated[index] = updatedDraft;
    return copyWith(workOrders: updated);
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

  bool get isBasicInfoValid =>
      title.trim().isNotEmpty && description.trim().isNotEmpty;

  @override
  List<Object?> get props => [
        id,
        isActive,
        title,
        description,
        accessType,
        requestApprovalAccess,
        intakeForm,
        reviewForm,
        workOrders,
      ];
}

extension ServiceDraftMapper on ServiceDraft {
  ServiceEntity toEntity() {
    if (!isBasicInfoValid) {
      throw ValidationException("Informasi dasar service belum lengkap");
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

    return ServiceEntity(
      id: id,
      title: title.trim(),
      description: description.trim(),
      accessType: accessType,
      isActive: isActive,
      serviceRequestConfig: ServiceRequestConfigEntity(
        intakeForm: intakeForm!,
        reviewForm: reviewForm!,
        serviceRequestApprovalAccessType: requestApprovalAccess,
        reviewNeed: true, // TODO : thinks later
      ),
      workOrdersConfig: workOrders.map((e) => e.toEntity()).toList(),
    );
  }
}
