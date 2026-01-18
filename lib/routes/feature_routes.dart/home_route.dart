import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/home/presentation/pages/homepage/homepage.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

final homeRouter = [
  GoRoute(
    path: AppRoutes.home,
    builder: (_, __) => const Homepage(),
  ),
];