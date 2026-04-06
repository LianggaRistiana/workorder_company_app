import 'package:workorder_company_app/core/authorization/rule/authorization_result.dart';
import 'package:workorder_company_app/core/authorization/rule/authorization_rule.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';

class RequesterServiceRequestPolicy {
  final RequesterServiceRequestEntity request;

  const RequesterServiceRequestPolicy({required this.request});

  AuthorizationRule get cancelRule =>
      _CancelServiceRequestRule(request: request);
  AuthorizationRule get fillReviewRule => _FillReviewFormRule(request: request);
}

class _CancelServiceRequestRule extends AuthorizationRule {
  final RequesterServiceRequestEntity request;
  _CancelServiceRequestRule({required this.request});

  // @override
  // bool isAllowed(UserEntity user) {
  //   return allOf([
  //     () => user.role.canPermission(ServiceRequestPermission.cancel),
  //     () => request.status == ServiceRequestStatus.received,
  //     () => request.requestedBy.email == user.email,
  //   ]);
  // }

  @override
  AuthorizationResult evaluate(UserEntity user) {
    // TODO: implement evaluate
    throw UnimplementedError();
  }
}

class _FillReviewFormRule extends AuthorizationRule {
  final RequesterServiceRequestEntity request;
  _FillReviewFormRule({required this.request});

  // @override
  // bool isAllowed(UserEntity user) {
  //   return allOf([
  //     () => user.role.canPermission(ServiceRequestPermission.update),
  //     () => request.status == ServiceRequestStatus.completed,
  //     () => request.requestedBy.email == user.email,
  //   ]);
  // }

  @override
  AuthorizationResult evaluate(UserEntity user) {
    // TODO: implement evaluate
    throw UnimplementedError();
  }
}
