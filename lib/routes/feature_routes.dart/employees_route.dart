import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/employees/presentation/page/employees_page.dart';
import 'package:workorder_company_app/features/invitations/presentation/pages/invite_employees_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/wrapper/employees_wrapper.dart';

final employeesRouter = [
  ShellRoute(
    builder: (context, state, child) => EmployeesWrapper(child : child),
    routes: [
    GoRoute(
      path: AppRoutes.employee,
      builder: (_, __) => const EmployeesPage(),
    ),
    GoRoute(
      path: AppRoutes.employeeInvite,
      builder: (_, __) => const InviteEmployeePage(),
    ),
  ])
];
