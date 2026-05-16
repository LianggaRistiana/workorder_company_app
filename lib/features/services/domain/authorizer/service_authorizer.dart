import 'package:workorder_company_app/core/authorization/feature/service_permission.dart';
import 'package:workorder_company_app/core/authorization/model/authorization_result.dart';
import 'package:workorder_company_app/core/authorization/rule/authorization_rule.dart';
import 'package:workorder_company_app/core/authorization/rule/composite_rule/composite_rule_helper.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission_rule/role_permission_helper.dart';
import 'package:workorder_company_app/core/constants/app_enums/service_enum.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';

class ServiceAuthorizer {
  final ServiceEntity service;

  const ServiceAuthorizer({
    required this.service,
  });

  AuthorizationRule get editRule => rules([
        roleCan(ServicePermission.update),
        _ManagerDepartementScopeRule(service),
      ]);

  AuthorizationRule get editCheckingDataRule => rules([
        roleCan(ServicePermission.update),
        _ManagerDepartementScopeRule(service),
        _AutoDraftingConfigRule(service),
      ]);

  AuthorizationRule get createCheckingDataRule => rules([
        roleCan(ServicePermission.create),
        _ManagerDepartementScopeRule(service),
        _AutoDraftingConfigRule(service),
      ]);
}

class _ManagerDepartementScopeRule extends AuthorizationRule {
  final ServiceEntity service;

  _ManagerDepartementScopeRule(this.service);

  @override
  AuthorizationResult evaluate(UserEntity user) {
    final position = user.position;

    if (position != null) {
      if (!hasDepartmentAccess(position.id)) {
        return AuthorizationResult.denied(
          "Manajer Departemen ${position.name} tidak bisa mengakses layanan ini",
        );
      }
    }

    return AuthorizationResult.allowed();
  }

  bool hasDepartmentAccess(String positionId) {
    return service.workOrdersConfig.any(
      (e) => e.positionOnDuty.id == positionId,
    );
  }
}

class _AutoDraftingConfigRule extends AuthorizationRule {
  final ServiceEntity service;

  _AutoDraftingConfigRule(this.service);

  @override
  AuthorizationResult evaluate(UserEntity user) {
    final isAuto = service.workOrderDraftingType == WorkOrderDraftingType.auto;

    final isManual =
        service.workOrderDraftingType == WorkOrderDraftingType.manual;

    if (isAuto) {
      final hasWorkOrderForm = service.workOrdersConfig.any(
        (e) => e.workOrderForm != null,
      );

      if (hasWorkOrderForm) {
        return AuthorizationResult.denied(
          "Auto drafting tidak boleh memiliki work order form",
        );
      }

      final hasManualApproval = service.workOrdersConfig.any(
        (e) =>
            e.workOrderAprrovalAccessType != WorkOrderAprrovalAccess.auto ||
            e.workReportApprovalAccessType != WorkReportApprovalAccess.auto,
      );

      if (hasManualApproval) {
        return AuthorizationResult.denied(
          "Auto drafting wajib menggunakan auto approval",
        );
      }

      final requestApprovalInvalid =
          service.serviceRequestConfig.serviceRequestApprovalAccessType !=
              ServiceRequestApprovalAccess.auto;

      if (requestApprovalInvalid) {
        return AuthorizationResult.denied(
          "Service request approval wajib auto",
        );
      }
    }

    if (isManual) {
      final hasNullForm = service.workOrdersConfig.any(
        (e) => e.workOrderForm == null,
      );

      if (hasNullForm) {
        return AuthorizationResult.denied(
          "Manual drafting wajib memiliki work order form",
        );
      }
    }

    return AuthorizationResult.allowed();
  }
}
