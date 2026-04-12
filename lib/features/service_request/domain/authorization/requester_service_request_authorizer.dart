import 'package:workorder_company_app/core/authorization/feature/service_request_permission.dart';
import 'package:workorder_company_app/core/authorization/model/authorization_result.dart';
import 'package:workorder_company_app/core/authorization/rule/authorization_rule.dart';
import 'package:workorder_company_app/core/authorization/rule/composite_rule/composite_rule_helper.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission_rule/role_permission_helper.dart';
import 'package:workorder_company_app/core/authorization/util/check_permission.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/condition_evaluator.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';

class RequesterServiceRequestAuthorizer {
  final RequesterServiceRequestEntity request;

  const RequesterServiceRequestAuthorizer({
    required this.request,
  });

  AuthorizationRule get cancelRule => rules([
        roleCan(ServiceRequestPermission.cancel),
        _ServiceRequestStatusRule(request, ServiceRequestStatus.received),
        _ServiceRequestOwner(request)
      ]);

  AuthorizationRule get reviewRule => rules([
        roleCan(ServiceRequestPermission.update),
        _ServiceRequestStatusRule(request, ServiceRequestStatus.completed),
        _ServiceRequestOwner(request)
      ]);

  // AuthorizationRule get internalCreateRule => rules([
  //       roleCan(ServiceRequestPermission.create),
  //       _InternalServiceRequestCreate()
  //     ]);
}

class InternalServiceRequestCreateRule extends AuthorizationRule {
  @override
  AuthorizationResult evaluate(UserEntity user) {
    if (allOf([
      () => user.role.canPermission(ServiceRequestPermission.create),
      () => user.role == UserRole.staffCompany
    ])) {
      return const AuthorizationResult.allowed();
    } else {
      return const AuthorizationResult.denied(
        'Anda tidak dapat melakukan ini',
      );
    }
  }
}

class _ServiceRequestOwner extends AuthorizationRule {
  final RequesterServiceRequestEntity request;

  _ServiceRequestOwner(this.request);

  @override
  AuthorizationResult evaluate(UserEntity user) {
    if (request.requestedBy.email == user.email) {
      return const AuthorizationResult.allowed();
    }

    return const AuthorizationResult.denied(
      'Anda bukan pemilik permintaan ini',
    );
  }
}

class _ServiceRequestStatusRule extends AuthorizationRule {
  final RequesterServiceRequestEntity request;
  final ServiceRequestStatus expectedStatus;

  _ServiceRequestStatusRule(
    this.request,
    this.expectedStatus,
  );

  @override
  AuthorizationResult evaluate(UserEntity user) {
    if (request.status == expectedStatus) {
      return const AuthorizationResult.allowed();
    }

    return AuthorizationResult.denied(
      'Status ${request.status} tidak memenuhi syarat',
    );
  }
}
