import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/employees/presentation/page/employees_page.dart';
import 'package:workorder_company_app/features/employees/presentation/page/invite_employees_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

final employeesRouter = [
  GoRoute(
    path: AppRoutes.employee,
    builder: (_, __) => const EmployeesPage(),
  ),
  GoRoute(
    path: AppRoutes.employeeInvite,
    builder: (_, __) => const InviteEmployeePage(),
  ),
];
