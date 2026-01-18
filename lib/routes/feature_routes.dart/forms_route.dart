import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/forms/presentation/pages/forms/forms_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

final formsRouter = [
  GoRoute(
    path: AppRoutes.forms,
    builder: (_, __) => const FormsPage(),
  )
];