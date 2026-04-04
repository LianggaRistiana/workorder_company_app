import 'package:workorder_company_app/core/authorization/feature/service_request_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/permission_rule.dart';
import 'package:workorder_company_app/core/authorization/util/check_permission.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/condition_evaluator.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';

class ProviderServiceRequestPolicy {
  final ProviderServiceRequestEntity request;

  ProviderServiceRequestPolicy({required this.request});

  PermissionRule get approvalRule =>
      _ServicesRequestApprovalRule(request: request);

  PermissionRule get rejectRule => _ServicesRequestRejectRule(request: request);
}

/// Rule khusus untuk approve service request
class _ServicesRequestApprovalRule extends PermissionRule {
  final ProviderServiceRequestEntity request;

  _ServicesRequestApprovalRule({required this.request});

  @override
  bool isAllowed(UserEntity user) {
    return allOf([
      () => user.role.canPermission(ServiceRequestPermission.approve),
      () => request.status == ServiceRequestStatus.received,
      () => request.approvalAccess == ServiceRequestApprovalAccess.manager,
    ]);
  }
}

class _ServicesRequestRejectRule extends PermissionRule {
  final ProviderServiceRequestEntity request;

  _ServicesRequestRejectRule({required this.request});

  @override
  bool isAllowed(UserEntity user) {
    return allOf([
      () => user.role.canPermission(ServiceRequestPermission.reject),
      () => request.status == ServiceRequestStatus.received,
      () => request.approvalAccess == ServiceRequestApprovalAccess.manager,
    ]);
  }
}
