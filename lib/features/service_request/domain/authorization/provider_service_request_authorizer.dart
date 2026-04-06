import 'package:workorder_company_app/core/authorization/feature/service_request_permission.dart';
import 'package:workorder_company_app/core/authorization/model/authorization_result.dart';
import 'package:workorder_company_app/core/authorization/rule/authorization_rule.dart';
import 'package:workorder_company_app/core/authorization/rule/composite_rule/composite_rule_helper.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission_rule/role_permission_helper.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';

class ProviderServiceRequestAuthorizer {
  final ProviderServiceRequestEntity request;

  const ProviderServiceRequestAuthorizer(this.request);

  AuthorizationRule get approveRule => rules([
        roleCan(ServiceRequestPermission.approve),
        _ServiceRequestStatusRule(request, ServiceRequestStatus.received),
      ]);

  AuthorizationRule get rejectRule => rules([
        roleCan(ServiceRequestPermission.reject),
        _ServiceRequestStatusRule(request, ServiceRequestStatus.received),
      ]);
}

class _ServiceRequestStatusRule extends AuthorizationRule {
  final ProviderServiceRequestEntity request;
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
