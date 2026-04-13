import 'package:workorder_company_app/core/authorization/feature/company_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/employee_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/form_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/invitation_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/memberships_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/positions_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/public_companies_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/service_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/service_request_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/workreport_permission.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/work_order_permission.dart';
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
          ...WorkOrderPermissions.all,
          ...WorkReportPermissions.all,
          ...InvitationPermission.sender,
          ...MembershipsPermission.provider,
          ...ServiceRequestPermission.receiver
        };
      case UserRole.managerCompany:
        return {
          CompanyPermission.view,
          PositionsPermission.view,
          EmployeePermission.view,
          FormPermission.view,
          ServicePermission.view,
          ...WorkOrderPermissions.creator,
          ...WorkReportPermissions.all,
          ...ServiceRequestPermission.receiver,
          MembershipsPermission.view
        };
      case UserRole.staffCompany:
        return {
          CompanyPermission.view,
          PositionsPermission.view,
          EmployeePermission.view,
          FormPermission.view,
          ServicePermission.view,
          ...WorkOrderPermissions.worker,
          ...ServiceRequestPermission.requester,
          ...WorkReportPermissions.all
        };
      case UserRole.client:
        return {
          PublicCompaniesPermission.view,
          MembershipsPermission.claim,
          ...ServiceRequestPermission.requester,
        };
      case UserRole.staffUnassigned:
        return {...InvitationPermission.receiver};
    }
  }
}
