import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/positions/presentation/pages/positions_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/wrapper/position_wrapper.dart';

final positionsRouter = [
  ShellRoute(
      builder: (context, state, child) {
        return PositionWrapper(child: child);
      },
      routes: [
        GoRoute(
            path: AppRoutes.positions,
            builder: (_, __) => const PositionsPage()),
            // Route lain disini
      ])
];
