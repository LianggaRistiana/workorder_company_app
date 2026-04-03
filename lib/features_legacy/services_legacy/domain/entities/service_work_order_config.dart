import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

class ServiceWorkOrderConfig extends Equatable {
  final FormEntity workOrderForm;
  final FormEntity? reportForm;
  final int minStaff;
  final int maxStaff;
  final PositionEntity? departmentOnDuty;
  final WorkOrderAprrovalAccess workOrderApprovalAccess;
  final WorkReportApprovalAccess workReportApprovalAccess;

  const ServiceWorkOrderConfig({
    required this.workOrderForm,
    required this.reportForm,
    required this.minStaff,
    required this.maxStaff,
    this.departmentOnDuty,
    required this.workOrderApprovalAccess,
    required this.workReportApprovalAccess,
  });

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
