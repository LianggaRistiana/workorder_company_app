import 'package:workorder_company_app/core/authorization/feature/employee_permission.dart';
import 'package:workorder_company_app/core/authorization/model/authorization_result.dart';
import 'package:workorder_company_app/core/authorization/rule/authorization_rule.dart';
import 'package:workorder_company_app/core/authorization/rule/composite_rule/composite_rule_helper.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission_rule/role_permission_helper.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/employees/domain/meta/employee_detail_meta.dart';

class EmployeeAuthorizer {
  final UserEntity staff;
  final EmployeeDetailMeta? meta;

  const EmployeeAuthorizer({
    required this.staff,
    this.meta,
  });

  AuthorizationRule get removeEmployeeRule => rules([
        roleCan(EmployeePermission.delete),
        _ManagerScopeRule(staff),
        _MetaCapabilityRule(meta),
      ]);
}

class _ManagerScopeRule extends AuthorizationRule {
  final UserEntity staff;

  _ManagerScopeRule(this.staff);

  @override
  AuthorizationResult evaluate(UserEntity user) {
    if (user.role == UserRole.ownerCompany) {
      return AuthorizationResult.allowed();
    }

    final isManager = user.role == UserRole.managerCompany;
    final isStaff = staff.role == UserRole.staffCompany;

    if (isManager && isStaff) {
      // General Manager
      if (user.position == null) {
        return AuthorizationResult.allowed();
      }

      // Department Manager
      if (user.position == staff.position) {
        return AuthorizationResult.allowed();
      }
    }

    return AuthorizationResult.denied(
      "Tidak memiliki akses untuk melakukan aksi ini",
    );
  }
}

class _MetaCapabilityRule extends AuthorizationRule {
  final EmployeeDetailMeta? meta;

  _MetaCapabilityRule(this.meta);

  @override
  AuthorizationResult evaluate(UserEntity user) {
    if (meta?.canKick == true) {
      return AuthorizationResult.allowed();
    }

    return AuthorizationResult.denied(
      "Tidak memiliki akses untuk melakukan aksi ini",
    );
  }
}
