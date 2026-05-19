import 'package:workorder_company_app/core/authorization/feature/work_report_permission.dart';
import 'package:workorder_company_app/core/authorization/model/authorization_result.dart';
import 'package:workorder_company_app/core/authorization/rule/authorization_rule.dart';
import 'package:workorder_company_app/core/authorization/rule/composite_rule/composite_rule_helper.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission_rule/role_permission_helper.dart';
import 'package:workorder_company_app/core/constants/app_enums/service_enum.dart';
import 'package:workorder_company_app/core/constants/app_enums/work_report_enum.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_entity.dart';

class WorkReportAuthorizer {
  final WorkReportEntity workReport;
  final WorkOrderEntity workOrder;

  const WorkReportAuthorizer(
      {required this.workReport, required this.workOrder});

  AuthorizationRule get approveWorkReport => rules([
        roleCan(WorkReportPermissions.approve),
        _ManagerDepartementScopeRule(workOrder),
        _StatusValidation(
          currentStatus: workReport.status,
          expectedStatus: {
            WorkReportStatus.sent,
          },
        ),
        _ApprovalRequiresManual(workReport.approvalAccess)
      ]);

  AuthorizationRule get rejectWorkReport => rules([
        roleCan(WorkReportPermissions.reject),
        _ManagerDepartementScopeRule(workOrder),
        _StatusValidation(
          currentStatus: workReport.status,
          expectedStatus: {
            WorkReportStatus.sent,
          },
        ),
        _ApprovalRequiresManual(workReport.approvalAccess)
      ]);

  AuthorizationRule get sendWorkReport => rules([
        roleCan(WorkReportPermissions.send),
        _StatusValidation(
          currentStatus: workReport.status,
          expectedStatus: {
            WorkReportStatus.onProgress,
          },
        ),
        _CheckPic(workOrder)
      ]);

  AuthorizationRule get fillWorkReport => rules([
        roleCan(WorkReportPermissions.fill),
        _StatusValidation(
          currentStatus: workReport.status,
          expectedStatus: {
            WorkReportStatus.onProgress,
            WorkReportStatus.rejected,
          },
        ),
        _CheckPic(workOrder)
      ]);
}

class _ManagerDepartementScopeRule extends AuthorizationRule {
  final WorkOrderEntity workOrder;

  _ManagerDepartementScopeRule(this.workOrder);

  @override
  AuthorizationResult evaluate(UserEntity user) {
    final position = user.position;

    if (position != null) {
      final positionId = position.id;

      if (!hasDepartmentAccess(positionId)) {
        return AuthorizationResult.denied(
          "Manajer Departemen ${position.name} tidak punya akses untuk aksi ini",
        );
      }
    }
    return AuthorizationResult.allowed();
  }

  bool hasDepartmentAccess(String positionId) {
    return workOrder.positionOnDuty.id == positionId;
  }
}

class _StatusValidation extends AuthorizationRule {
  final WorkReportStatus currentStatus;
  final Set<WorkReportStatus> expectedStatus;

  _StatusValidation({
    required this.currentStatus,
    required this.expectedStatus,
  });

  @override
  AuthorizationResult evaluate(UserEntity user) {
    if (expectedStatus.contains(currentStatus)) {
      return const AuthorizationResult.allowed();
    }
    return AuthorizationResult.denied(
      'Status ${currentStatus.displayName} tidak memenuhi syarat untuk melakukan aksi ini',
    );
  }
}

class _CheckPic extends AuthorizationRule {
  final WorkOrderEntity workOrder;

  _CheckPic(this.workOrder);

  @override
  AuthorizationResult evaluate(UserEntity user) {
    if (workOrder.staffPic == null) {
      return const AuthorizationResult.allowed();
    }
    if (workOrder.staffPic!.email == user.email) {
      return const AuthorizationResult.allowed();
    }
    return const AuthorizationResult.denied(
      "Hanya Penanggung Jawab yang dapat melakukan aksi ini",
    );
  }
}

class _ApprovalRequiresManual extends AuthorizationRule {
  final WorkReportApprovalAccess type;

  _ApprovalRequiresManual(this.type);

  @override
  AuthorizationResult evaluate(UserEntity user) {
    if (type != WorkReportApprovalAccess.auto) {
      return const AuthorizationResult.allowed();
    }

    return AuthorizationResult.denied(
      'Work report menggunakan approval otomatis',
    );
  }
}
