import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/work_order_config_entity.dart';

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

  /// =========================
  /// FACTORY
  /// =========================

  factory ServiceWorkOrderConfigDraft.initial({
    required FormEntity workOrderForm,
  }) {
    return ServiceWorkOrderConfigDraft(
      workOrderForm: workOrderForm,
    );
  }

  factory ServiceWorkOrderConfigDraft.fromEntity(
    WorkOrderConfigEntity entity,
  ) {
    return ServiceWorkOrderConfigDraft(
      workOrderForm: entity.workOrderForm,
      reportForm: entity.workReportForm,
      minStaff: entity.minStaff,
      maxStaff: entity.maxStaff,
      departmentOnDuty: entity.positionOnDuty,
      workOrderApprovalAccess: entity.workOrderAprrovalAccessType,
      workReportApprovalAccess: entity.workReportApprovalAccessType,
    );
  }

  /// =========================
  /// SAFE COPY WITH (Nullable Support)
  /// =========================

  ServiceWorkOrderConfigDraft copyWith({
    FormEntity? workOrderForm,
    Object? reportForm = _noChange,
    Object? minStaff = _noChange,
    Object? maxStaff = _noChange,
    Object? departmentOnDuty = _noChange,
    WorkOrderAprrovalAccess? workOrderApprovalAccess,
    WorkReportApprovalAccess? workReportApprovalAccess,
  }) {
    return ServiceWorkOrderConfigDraft(
      workOrderForm: workOrderForm ?? this.workOrderForm,
      reportForm:
          reportForm == _noChange ? this.reportForm : reportForm as FormEntity?,
      minStaff: minStaff == _noChange ? this.minStaff : minStaff as int?,
      maxStaff: maxStaff == _noChange ? this.maxStaff : maxStaff as int?,
      departmentOnDuty: departmentOnDuty == _noChange
          ? this.departmentOnDuty
          : departmentOnDuty as PositionEntity?,
      workOrderApprovalAccess:
          workOrderApprovalAccess ?? this.workOrderApprovalAccess,
      workReportApprovalAccess:
          workReportApprovalAccess ?? this.workReportApprovalAccess,
    );
  }

  /// =========================
  /// VALIDATION HELPERS (UI LEVEL)
  /// =========================

  bool get hasDepartment => departmentOnDuty != null;

  bool get isStaffValid {
    if (minStaff == null || maxStaff == null) return false;
    if (minStaff! < 0 || maxStaff! < 0) return false;
    if (minStaff! > maxStaff!) return false;
    return true;
  }

  bool get isValidBasic => hasDepartment;

  /// =========================

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

/// Private marker
const _noChange = Object();

extension WorkOrderDraftMapper on ServiceWorkOrderConfigDraft {
  WorkOrderConfigEntity toEntity() {
    if (reportForm == null) {
      throw ValidationException("Work report form wajib dipilih");
    }

    if (departmentOnDuty == null) {
      throw ValidationException("Department wajib dipilih");
    }

    if (minStaff == null || maxStaff == null) {
      throw ValidationException("Min & Max staff wajib diisi");
    }

    if (minStaff! < 0 || maxStaff! < 0) {
      throw ValidationException("Staff tidak boleh negatif");
    }

    if (minStaff! > maxStaff!) {
      throw ValidationException(
          "Min staff tidak boleh lebih besar dari max staff");
    }

    return WorkOrderConfigEntity(
      workOrderForm: workOrderForm,
      workReportForm: reportForm!,
      positionOnDuty: departmentOnDuty!,
      workOrderAprrovalAccessType: workOrderApprovalAccess,
      workReportApprovalAccessType: workReportApprovalAccess,
      minStaff: minStaff!,
      maxStaff: maxStaff!,
    );
  }
}
