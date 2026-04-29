import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_entity.dart';
import 'package:workorder_company_app/features/work_report/presentation/pages/work_report_fill_form_page.dart';
import 'package:workorder_company_app/features/work_report/presentation/pages/work_report_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/routes/guards/route_guard.dart';

final workReportRouter = [
  GoRoute(
    path: AppRoutes.workReport,
    redirect: requireExtra<WorkOrderEntity>(),
    builder: (_, state) {
      final workOrder = state.extra as WorkOrderEntity;
      return WorkReportPage(workOrder: workOrder);
    },
  ),
  GoRoute(
    path: AppRoutes.workReportSubmission,
    redirect: requireExtra<WorkReportEntity>(),
    builder: (_, state) {
      final workReport = state.extra as WorkReportEntity;
      return WorkReportFillFormPage(
        workReport: workReport,
      );
    },
  ),
];
