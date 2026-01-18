import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/workorder/presentation/pages/workorders_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

final workorderRouter = [
  GoRoute(
    path: AppRoutes.workorders,
    builder: (_, __) => const WorkordersPage(),
  )
];
