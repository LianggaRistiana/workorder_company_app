import 'package:workorder_company_app/core/authorization/feature/service_request_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/permission_rule.dart';
import 'package:workorder_company_app/core/authorization/util/check_permission.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/condition_evaluator.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';

class RequesterServiceRequestPolicy {
  final RequesterServiceRequestEntity request;

  const RequesterServiceRequestPolicy({required this.request});

  PermissionRule get cancelRule => _CancelServiceRequestRule(request: request);
  PermissionRule get fillReviewRule => _FillReviewFormRule(request: request);
}

class _CancelServiceRequestRule extends PermissionRule {
  final RequesterServiceRequestEntity request;
  _CancelServiceRequestRule({required this.request});

  @override
  bool isAllowed(UserEntity user) {
    return allOf([
      () => user.role.canPermission(ServiceRequestPermission.cancel),
      () => request.status == ServiceRequestStatus.received,
      () => request.requestedBy.email == user.email,
    ]);
  }
}

class _FillReviewFormRule extends PermissionRule {
  final RequesterServiceRequestEntity request;
  _FillReviewFormRule({required this.request});

  @override
  bool isAllowed(UserEntity user) {
    return allOf([
      () => user.role.canPermission(ServiceRequestPermission.update),
      () => request.status == ServiceRequestStatus.completed,
      () => request.requestedBy.email == user.email,
    ]);
  }
}
