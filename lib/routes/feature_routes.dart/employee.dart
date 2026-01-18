import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/employees/presentation/page/employees_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

final employeeRouter = [
  GoRoute(
    path: AppRoutes.employee,
    builder: (_, __) => const EmployeesPage(),
  )
];
