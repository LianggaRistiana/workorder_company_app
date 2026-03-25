import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_request_config_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/work_order_config_entity.dart';

enum ServiceCreateStatus {
  initial,
  loading,
  success,
  error,
}

class ServiceCreateState extends Equatable {
  final ServiceCreateStatus status;
  final String? errorMessage;
  final ServiceConfig serviceConfig;

  const ServiceCreateState({
    required this.status,
    this.errorMessage,
    this.serviceConfig = const ServiceConfig(),
  });

  ServiceCreateState copyWith({
    ServiceCreateStatus? status,
    String? errorMessage,
    ServiceConfig? serviceConfig,
  }) {
    return ServiceCreateState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      serviceConfig: serviceConfig ?? this.serviceConfig,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        serviceConfig,
      ];
}

class ServiceConfig extends Equatable {
  final String title;
  final String description;
  final ServiceAccessType accessType;
  final ServiceRequestApprovalAccess serviceRequestApprovalAccess;
  final FormEntity? intakeForm;
  final FormEntity? reviewForm;
  final bool isActive;
  final List<ServiceWorkOrderConfigDraft> workOrderConfigs;

  const ServiceConfig({
    this.title = '',
    this.description = '',
    this.accessType = ServiceAccessType.internal,
    this.serviceRequestApprovalAccess = ServiceRequestApprovalAccess.manager,
    this.intakeForm,
    this.reviewForm,
    this.workOrderConfigs = const [],
    this.isActive = true,
  });

  ServiceConfig copyWith({
    String? title,
    String? description,
    List<PositionEntity>? departments,
    ServiceAccessType? accessType,
    ServiceRequestApprovalAccess? serviceRequestApprovalAccess,
    FormEntity? intakeForm,
    FormEntity? reviewForm,
    List<ServiceWorkOrderConfigDraft>? workOrderConfigs,
    bool? isActive,
  }) {
    return ServiceConfig(
      title: title ?? this.title,
      description: description ?? this.description,
      accessType: accessType ?? this.accessType,
      serviceRequestApprovalAccess:
          serviceRequestApprovalAccess ?? this.serviceRequestApprovalAccess,
      intakeForm: intakeForm ?? this.intakeForm,
      reviewForm: reviewForm ?? this.reviewForm,
      workOrderConfigs: workOrderConfigs ?? this.workOrderConfigs,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        title,
        description,
        accessType,
        serviceRequestApprovalAccess,
        intakeForm,
        reviewForm,
        workOrderConfigs,
        isActive,
      ];
}

class ServiceWorkOrderConfigDraft extends Equatable {
  final FormEntity workOrderForm;
  final FormEntity? reportForm;
  final int? minStaff;
  final int? maxStaff;
  final PositionEntity? departmentOnDuty;
  final WorkOrderAprrovalAccess workOrderApprovalAccess;
  final WorkReportApprovalAccess workReportApprovalAccess;

  const ServiceWorkOrderConfigDraft({
    required this.workOrderForm,
    this.reportForm,
    this.minStaff,
    this.maxStaff,
    this.departmentOnDuty,
    this.workOrderApprovalAccess = WorkOrderAprrovalAccess.staffPic,
    this.workReportApprovalAccess = WorkReportApprovalAccess.manager,
  });

  ServiceWorkOrderConfigDraft copyWith({
    FormEntity? workOrderForm,
    FormEntity? reportForm,
    int? minStaff,
    int? maxStaff,
    PositionEntity? departmentOnDuty,
    WorkOrderAprrovalAccess? workOrderApprovalAccess,
    WorkReportApprovalAccess? workReportApprovalAccess,
  }) {
    return ServiceWorkOrderConfigDraft(
      workOrderForm: workOrderForm ?? this.workOrderForm,
      reportForm: reportForm ?? this.reportForm,
      minStaff: minStaff ?? this.minStaff,
      maxStaff: maxStaff ?? this.maxStaff,
      departmentOnDuty: departmentOnDuty ?? this.departmentOnDuty,
      workOrderApprovalAccess:
          workOrderApprovalAccess ?? this.workOrderApprovalAccess,
      workReportApprovalAccess:
          workReportApprovalAccess ?? this.workReportApprovalAccess,
    );
  }

  @override
  List<Object?> get props => [
        workOrderForm,
        reportForm,
        minStaff,
        maxStaff,
        departmentOnDuty,
        workOrderApprovalAccess,
        workReportApprovalAccess,
      ];
}


extension ServiceConfigMapper on ServiceConfig {
  ServiceEntity toEntity({required String id}) {
    return ServiceEntity(
      id: id,
      title: title,
      description: description,
      accessType: accessType,
      isActive: isActive,
      serviceRequestConfig: ServiceRequestConfigEntity(
        intakeForm: intakeForm!,
        reviewForm: reviewForm!,
        serviceRequestApprovalAccessType:
            serviceRequestApprovalAccess,
        reviewNeed: reviewForm != null,
      ),
      workOrdersConfig: workOrderConfigs
          .map((draft) => draft.toEntity())
          .toList(),
    );
  }
}

extension ServiceWorkOrderDraftMapper on ServiceWorkOrderConfigDraft {
  WorkOrderConfigEntity toEntity() {
    return WorkOrderConfigEntity(
      workOrderForm: workOrderForm,
      workReportForm: reportForm!,
      positionOnDuty: departmentOnDuty!,
      workOrderAprrovalAccessType: workOrderApprovalAccess,
      workReportApprovalAccessType: workReportApprovalAccess,
      minStaff: minStaff ?? 1,
      maxStaff: maxStaff ?? 1,
    );
  }
}