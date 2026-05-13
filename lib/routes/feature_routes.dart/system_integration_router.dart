import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/submissions/presentation/pages/lab_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

final systemIntegrationRouter = [
  GoRoute(
    path: AppRoutes.pairAccount,
    builder: (_, __) => LabPage(),
  ),
];
