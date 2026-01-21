import 'package:workorder_company_app/core/authorization/feature/company_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/csr_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/employee_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/form_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/invitation_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/positions_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/public_companies.dart';
import 'package:workorder_company_app/core/authorization/feature/service_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/workreport_permission.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/workorder_permission.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

extension UserRolePermissions on UserRole {
  Set<AppPermission> get permissions {
    switch (this) {
      case UserRole.ownerCompany:
        return {
          ...CompanyPermission.all,
          ...PositionsPermission.all,
          ...EmployeePermission.all,
          ...FormPermission.all,
          ...ServicePermission.all,
          ...CsrPermission.all,
          ...WorkOrderPermissions.all,
          ...WorkReportPermissions.all,
          ...InvitationPermission.admin
        };
      case UserRole.managerCompany:
        return {
          CompanyPermission.view,
          PositionsPermission.view,
          EmployeePermission.view,
          FormPermission.view,
          ServicePermission.view,
          ...CsrPermission.all,
          ...WorkOrderPermissions.all,
          ...WorkReportPermissions.all
        };
      case UserRole.staffCompany:
        return {
          CompanyPermission.view,
          PositionsPermission.view,
          EmployeePermission.view,
          FormPermission.view,
          ServicePermission.view,
          CsrPermission.view,
          WorkOrderPermissions.view,
          ...WorkReportPermissions.all
        };
      case UserRole.client:
        return {PublicCompanies.view, CsrPermission.view};
      case UserRole.staffUnassigned:
        return {...InvitationPermission.unassigned};
    }
  }
}
