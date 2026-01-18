import 'package:workorder_company_app/core/authorization/feature/employee_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/form_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/positions_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/service_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/workorder_permission.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

class RoutePermissions {
  static final Map<String, AppPermission> map = {
    // Posisitons Rote
    AppRoutes.positions: PositionsPermission.view,
    AppRoutes.positionsDetail: PositionsPermission.view,
    AppRoutes.positionsCreate: PositionsPermission.create,
    AppRoutes.positionsUpdate: PositionsPermission.update,

    // Employee
    AppRoutes.employee: EmployeePermission.view,
    AppRoutes.employeeDetail: EmployeePermission.view,
    AppRoutes.employeeInvite: EmployeePermission.create,

    // Form
    AppRoutes.forms: FormPermission.view,
    AppRoutes.formsDetail: FormPermission.view,
    AppRoutes.formsCreate: FormPermission.create,
    AppRoutes.formsUpdate: FormPermission.update,

    // Service
    AppRoutes.services: ServicePermission.view,
    AppRoutes.servicesDetail: ServicePermission.view,
    AppRoutes.servicesCreate: ServicePermission.create,
    AppRoutes.servicesUpdate: ServicePermission.update,

    // Work Order Route
    AppRoutes.workorders: WorkOrderPermissions.view,
    AppRoutes.workordersDetail: WorkOrderPermissions.view,
    AppRoutes.workordersSubmission: WorkOrderPermissions.update,
    // AppRoutes.workOrderAssign: WorkOrderPermissions.assign,
  };
}
