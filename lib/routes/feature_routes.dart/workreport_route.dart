import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/presentation/pages/workreport_page.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/presentation/pages/workreport_submission_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/wrapper/workreport_wrapper.dart';

final workreportRouter = [
  ShellRoute(
      builder: (context, state, child) => WorkreportWrapper(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.workreports,
          builder: (_, state) {
            final id = state.pathParameters['id']!;
            return WorkreportPage(
              workorderId: id,
            );
          },
        ),
        GoRoute(
          path: AppRoutes.workreportsSubmit,
          builder: (_, state) {
            final id = state.pathParameters['id']!;
            return WorkReportSubmissionPage(
              workorderId: id,
            );
          },
        )
      ])
];
