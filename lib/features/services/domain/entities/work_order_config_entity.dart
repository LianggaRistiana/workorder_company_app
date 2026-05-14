import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

class WorkOrderConfigEntity extends Equatable {
  final FormEntity? workOrderForm;
  final FormEntity workReportForm;
  final PositionEntity positionOnDuty;
  final WorkOrderAprrovalAccess workOrderAprrovalAccessType;
  final WorkReportApprovalAccess workReportApprovalAccessType;
  final int minStaff;
  final int maxStaff;
  final bool showReportToRequester;

  const WorkOrderConfigEntity({
    this.workOrderForm,
    required this.workReportForm,
    required this.positionOnDuty,
    required this.workOrderAprrovalAccessType,
    required this.workReportApprovalAccessType,
    required this.minStaff,
    required this.maxStaff,
    required this.showReportToRequester,
  });

  @override
  List<Object?> get props => [
        workOrderForm,
        workReportForm,
        positionOnDuty,
        workOrderAprrovalAccessType,
        workReportApprovalAccessType,
        minStaff,
        maxStaff,
        showReportToRequester,
      ];
}
