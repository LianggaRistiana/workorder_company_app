import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

class ServiceConfigState extends Equatable {
  final ServiceConfig serviceConfig;
  final bool isConfigLoading;
  final String? errorMessage;
  final bool isSubmitted;

  const ServiceConfigState({
    required this.serviceConfig,
    this.isConfigLoading = false,
    this.errorMessage,
    this.isSubmitted = false,
  });

  ServiceConfigState copyWith({
    ServiceConfig? serviceConfig,
    bool? isConfigLoading,
    String? errorMessage,
    bool? isSubmitted,
  }) {
    return ServiceConfigState(
      serviceConfig: serviceConfig ?? this.serviceConfig,
      isConfigLoading: isConfigLoading ?? this.isConfigLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }

  @override
  List<Object?> get props => [serviceConfig, isConfigLoading, errorMessage];
}

class ServiceConfig extends Equatable {
  final String title;
  final String description;
  final ServiceAccessType accessType;
  final List<PositionEntity> departments;
  final ServiceRequestApprovalAccess serviceRequestApprovalAccess;
  final FormEntity? intakeForm;
  final FormEntity? reviewForm;
  final bool isActive;
  final List<ServiceWorkOrderConfigDraft> workOrderConfigs;

  const ServiceConfig({
    this.title = '',
    this.description = '',
    this.accessType = ServiceAccessType.internal,
    this.departments = const [],
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
      departments: departments ?? this.departments,
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
        departments,
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
      reportForm : reportForm ?? this.reportForm,
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
