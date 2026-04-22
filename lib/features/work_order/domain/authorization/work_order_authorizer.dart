import 'package:workorder_company_app/core/authorization/feature/work_order_permission.dart';
import 'package:workorder_company_app/core/authorization/model/authorization_result.dart';
import 'package:workorder_company_app/core/authorization/rule/authorization_rule.dart';
import 'package:workorder_company_app/core/authorization/rule/composite_rule/composite_rule_helper.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission_rule/role_permission_helper.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/meta/work_order_meta.dart';

class WorkOrderAuthorizer {
  final WorkOrderEntity workOrder;
  final WorkOrderCapabilities? capabilities;

  const WorkOrderAuthorizer({
    required this.workOrder,
    this.capabilities, // FIXME : required this even if null to avoid denied on meta check even if capabilities doesnt needed
  });

  AuthorizationRule get sendWorkOrder => rules([
        roleCan(WorkOrderPermissions.send),
        _Ownership(workOrder),
        _StatusValidation(workOrder.status, WorkOrderStatus.drafted)
      ]);

  AuthorizationRule get fillWorkOrder => rules([
        roleCan(WorkOrderPermissions.fill),
        _Ownership(workOrder),
        _StatusValidation(workOrder.status, WorkOrderStatus.drafted)
      ]);

  AuthorizationRule get recreateWorkOrder => rules([
        roleCan(WorkOrderPermissions.create),
        _Ownership(workOrder),
        _StatusValidation(workOrder.status, WorkOrderStatus.rejected),
        _WorkOrderCapabilityRule(
            capabilities: capabilities, checker: (c) => c.canRecreate)
      ]);

  AuthorizationRule get approveWorkOrder => rules([
        roleCan(WorkOrderPermissions.approve),
        _StatusValidation(workOrder.status, WorkOrderStatus.sent),
        _OnlyStaffPicToReview(workOrder),
        _ApprovalRequiresManual(workOrder.approvalAccess)
      ]);

  AuthorizationRule get rejectWorkOrder => rules([
        roleCan(WorkOrderPermissions.reject),
        _StatusValidation(workOrder.status, WorkOrderStatus.sent),
        _OnlyStaffPicToReview(workOrder),
        _ApprovalRequiresManual(workOrder.approvalAccess)
      ]);

  AuthorizationRule get startWorkOrder => rules([
        roleCan(WorkOrderPermissions.start),
        _StatusValidation(workOrder.status, WorkOrderStatus.approved),
        _StaffPicOrEveryone(workOrder),
        _WorkOrderCapabilityRule(
            capabilities: capabilities, checker: (c) => c.canStart)
      ]);

  AuthorizationRule get cancelWorkOrder => rules([
        roleCan(WorkOrderPermissions.cancel),
        _Ownership(workOrder),
        _ValidCancelStatus(workOrder.status),
        _WorkOrderCapabilityRule(
            capabilities: capabilities, checker: (c) => c.canCancel)
      ]);

  AuthorizationRule get completeWorkOrder => rules([
        roleCan(WorkOrderPermissions.complete),
        _StatusValidation(workOrder.status, WorkOrderStatus.onProgress),
        _Ownership(workOrder),
        _WorkOrderCapabilityRule(
            capabilities: capabilities, checker: (c) => c.canComplete)
      ]);

  AuthorizationRule get failWorkOrder => rules([
        roleCan(WorkOrderPermissions.fail),
        _StatusValidation(workOrder.status, WorkOrderStatus.onProgress),
        _Ownership(workOrder),
        _WorkOrderCapabilityRule(
            capabilities: capabilities, checker: (c) => c.canFail)
      ]);
}

class _Ownership extends AuthorizationRule {
  final WorkOrderEntity workOrder;

  _Ownership(this.workOrder);

  @override
  AuthorizationResult evaluate(UserEntity user) {
    if (user.role == UserRole.ownerCompany) {
      return const AuthorizationResult.allowed();
    }

    if (workOrder.createdBy == null) {
      return const AuthorizationResult.allowed();
    }

    if (user.email == workOrder.createdBy!.email) {
      return const AuthorizationResult.allowed();
    }

    return const AuthorizationResult.denied(
      "Hanya Pembuat Perintah Kerja yang dapat melakukan aksi ini",
    );
  }
}

class _OnlyStaffPicToReview extends AuthorizationRule {
  final WorkOrderEntity workOrder;

  _OnlyStaffPicToReview(this.workOrder);

  @override
  AuthorizationResult evaluate(UserEntity user) {
    if (workOrder.approvalAccess != WorkOrderAprrovalAccess.staffPic) {
      return const AuthorizationResult.allowed();
    }

    final staffPic = workOrder.staffPic;

    if (staffPic == null) {
      return const AuthorizationResult.denied(
        "Staff PIC belum ditentukan",
      );
    }

    if (staffPic.email == user.email) {
      return const AuthorizationResult.allowed();
    }

    return const AuthorizationResult.denied(
      "Hanya Staff PIC yang dapat melakukan aksi ini",
    );
  }
}

class _StaffPicOrEveryone extends AuthorizationRule {
  final WorkOrderEntity workOrder;

  _StaffPicOrEveryone(this.workOrder);

  @override
  AuthorizationResult evaluate(UserEntity user) {
    final staffPic = workOrder.staffPic;

    if (staffPic == null) {
      return const AuthorizationResult.allowed();
    }

    if (staffPic.email == user.email) {
      return const AuthorizationResult.allowed();
    }

    return const AuthorizationResult.denied(
      "Hanya Staff PIC yang dapat melakukan aksi ini",
    );
  }
}

class _WorkOrderCapabilityRule extends AuthorizationRule {
  final WorkOrderCapabilities? capabilities;
  final bool Function(WorkOrderCapabilities) checker;

  _WorkOrderCapabilityRule({
    required this.capabilities,
    required this.checker,
  });

  @override
  AuthorizationResult evaluate(UserEntity user) {
    if (capabilities == null) {
      return const AuthorizationResult.denied(
        'Capability tidak tersedia',
      );
    }

    if (checker(capabilities!)) {
      return const AuthorizationResult.allowed();
    }

    return AuthorizationResult.denied("Aksi Tidak Dapat Dilakukan");
  }
}

class _ValidCancelStatus extends AuthorizationRule {
  final WorkOrderStatus currentStatus;

  _ValidCancelStatus(this.currentStatus);

  @override
  AuthorizationResult evaluate(UserEntity user) {
    if (currentStatus.isCancellable) {
      return const AuthorizationResult.allowed();
    }

    return AuthorizationResult.denied(
      'Status ${currentStatus.displayName} tidak memenuhi syarat',
    );
  }
}

class _StatusValidation extends AuthorizationRule {
  final WorkOrderStatus currentStatus;
  final WorkOrderStatus expectedStatus;

  _StatusValidation(this.currentStatus, this.expectedStatus);

  @override
  AuthorizationResult evaluate(UserEntity user) {
    if (currentStatus == expectedStatus) {
      return const AuthorizationResult.allowed();
    }

    return AuthorizationResult.denied(
      'Status ${currentStatus.displayName} tidak memenuhi syarat',
    );
  }
}

class _ApprovalRequiresManual extends AuthorizationRule {
  final WorkOrderAprrovalAccess type;

  _ApprovalRequiresManual(this.type);

  @override
  AuthorizationResult evaluate(UserEntity user) {
    if (type != WorkOrderAprrovalAccess.auto) {
      return const AuthorizationResult.allowed();
    }

    return AuthorizationResult.denied(
      'Status $type tidak memenuhi syarat',
    );
  }
}
