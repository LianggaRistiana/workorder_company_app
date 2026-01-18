import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/workorder_permission.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

extension UserRolePermissions on UserRole {
  Set<AppPermission> get permissions {
    switch (this) {
      case UserRole.ownerCompany:
        return {
          ...WorkOrderPermissions.all
        };
      case UserRole.managerCompany:
        return {
          ...WorkOrderPermissions.all
        };
      case UserRole.staffCompany:
        return {
          WorkOrderPermissions.view,
        };
      case UserRole.client:
        return{};
      default:
        return {};
    }
  }
}

