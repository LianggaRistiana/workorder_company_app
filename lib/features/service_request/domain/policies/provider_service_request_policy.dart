import 'package:workorder_company_app/core/authorization/rule/authorization_result.dart';
import 'package:workorder_company_app/core/authorization/rule/authorization_rule.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';

class ProviderServiceRequestPolicy {
  final ProviderServiceRequestEntity request;

  ProviderServiceRequestPolicy({required this.request});

  AuthorizationRule get approvalRule =>
      _ServicesRequestApprovalRule(request: request);

  AuthorizationRule get rejectRule => _ServicesRequestRejectRule(request: request);
}

/// Rule khusus untuk approve service request
class _ServicesRequestApprovalRule extends AuthorizationRule {
  final ProviderServiceRequestEntity request;

  _ServicesRequestApprovalRule({required this.request});

  @override
  AuthorizationResult evaluate(UserEntity user) {
    // TODO: implement evaluate
    throw UnimplementedError();
  }

      // @override
      // bool isAllowed(UserEntity user) {
      //   return allOf([
      //     () => user.role.canPermission(ServiceRequestPermission.approve),
      //     () => request.status == ServiceRequestStatus.received,
      //     () => request.approvalAccess == ServiceRequestApprovalAccess.manager,
      //   ]);
      // }
}

class _ServicesRequestRejectRule extends AuthorizationRule {
  final ProviderServiceRequestEntity request;

  _ServicesRequestRejectRule({required this.request});
  
  @override
  AuthorizationResult evaluate(UserEntity user) {
    // TODO: implement evaluate
    throw UnimplementedError();
  }

  // @override
  // bool isAllowed(UserEntity user) {
  //   return allOf([
  //     () => user.role.canPermission(ServiceRequestPermission.reject),
  //     () => request.status == ServiceRequestStatus.received,
  //     () => request.approvalAccess == ServiceRequestApprovalAccess.manager,
  //   ]);
  // }
}
