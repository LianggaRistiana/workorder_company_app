import 'package:workorder_company_app/core/authorization/feature/company_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/employee_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/faq_config_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/form_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/invitation_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/memberships_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/positions_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/public_companies_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/quick_config_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/service_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/service_request_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/system_integration_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/work_report_permission.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/work_order_permission.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

/// Maps each [UserRole] to its corresponding set of [AppPermission].
///
/// ---------------------------------------------------------------------------
/// ROLE-BASED ACCESS CONTROL (RBAC)
/// ---------------------------------------------------------------------------
///
/// This extension defines the static permission mapping for every supported
/// user role in the system. Each role is granted a specific set of
/// [AppPermission] that determines what actions the user is authorized to
/// perform.
///
/// The permission structure follows a domain-driven grouping:
///
/// - Company Domain
///   Handles company configuration and membership management.
///
/// - Human Resource Domain
///   Manages employees, positions, and internal invitations.
///
/// - Service Domain
///   Handles service configuration and form management.
///
/// - Work Order Domain
///   Manages service requests, work order lifecycle, and reporting.
///
/// ---------------------------------------------------------------------------
/// DESIGN PRINCIPLES
/// ---------------------------------------------------------------------------
///
/// • Centralized Permission Mapping
///   All role-to-permission definitions are declared in one place to ensure:
///   - Easier auditing
///   - Maintainability
///   - Consistent authorization behavior
///
/// • Set-Based Permission Model
///   Permissions are returned as a `Set<AppPermission>` to:
///   - Prevent duplication
///   - Ensure deterministic access control
///
/// • Resource-Oriented + Actor-Oriented Mix
///   Some permissions are grouped by resource scope (`.all`)
///   while others are grouped by actor responsibility (e.g. `.worker`,
///   `.reviewer`, `.receiver`). This reflects real business workflow roles.
///
/// ---------------------------------------------------------------------------
/// IMPORTANT NOTES
/// ---------------------------------------------------------------------------
///
/// - This mapping represents static RBAC configuration.
/// - Any dynamic or data-driven permission overrides must be handled
///   separately at the authorization.
/// - UI visibility should not be the only enforcement mechanism. Always
///   validate permissions in the domain/application layer.
///
/// ---------------------------------------------------------------------------
/// SECURITY CONSIDERATION
/// ---------------------------------------------------------------------------
///
/// This extension defines capability exposure, not enforcement.
/// Proper permission checks must still be executed before performing
/// sensitive operations.
///
/// ---------------------------------------------------------------------------
/// Example:
///
/// ```dart
/// if (userRole.permissions.contains(WorkOrderPermissions.create)) {
///   // Allow creation
/// }
/// ```
///
extension UserRolePermissions on UserRole {
  Set<AppPermission> get permissions {
    switch (this) {
      case UserRole.ownerCompany:
        return {
          // Company Domain
          ...CompanyPermission.all,
          ...MembershipsPermission.provider,
          ...FaqConfigPermission.all,
          ...QuickConfigPermission.all,
          ...SystemIntegrationPermission.config,

          // Human Resource Domain
          ...PositionsPermission.all,
          ...EmployeePermission.all,
          ...InvitationPermission.sender,

          // Service Domain
          // TODO : Check this changes
          ...FormPermission.all,
          ...ServicePermission.all,

          // Work Order Domain
          ...ServiceRequestPermission.provider,
          ...WorkOrderPermissions.all,
          ...WorkReportPermissions.reviewer,
        };
      case UserRole.managerCompany:
        return {
          // Company Domain
          CompanyPermission.view,
          MembershipsPermission.view,

          // Human Resouce Domain
          PositionsPermission.view,
          EmployeePermission.view,
          ...InvitationPermission.sender, // TODO : Check this

          // Service Domain
          ...FormPermission.all,
          ...ServicePermission.all,

          // Work Order Domain
          ...ServiceRequestPermission.provider,
          ...WorkOrderPermissions.creator,
          ...WorkReportPermissions.reviewer,
        };
      case UserRole.staffCompany:
        return {
          // Company Domain
          CompanyPermission.view,

          // Human Resouce
          PositionsPermission.view,
          EmployeePermission.view,

          // Service Domains
          FormPermission.view,
          ServicePermission.view,

          // Work Order Domain
          ...ServiceRequestPermission
              .requester, // HACK : Potentially move to manager level
          ...WorkOrderPermissions.worker,
          ...WorkReportPermissions.worker
        };
      case UserRole.client:
        return {
          // Company Domain
          PublicCompaniesPermission.view,
          MembershipsPermission.claim,

          // Work Order Domain
          ...ServiceRequestPermission.requester,

          // Account
          ...SystemIntegrationPermission.pairing,
        };
      case UserRole.staffUnassigned:
        return {
          // Human Resource Domain
          ...InvitationPermission.receiver,
        };
    }
  }
}
