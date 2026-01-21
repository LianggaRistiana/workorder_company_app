import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/company/presentation/pages/owner_company_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

final companyRouter = [
  GoRoute(
    path: AppRoutes.companyManageMenu,
    builder: (context, state) => OwnerCompanyPage(),
  ),
  // ShellRoute(routes: [

  // ])
];
