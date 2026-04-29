import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/services/logger/app_logger.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/params/work_order_params.dart';
import 'package:workorder_company_app/features/work_order/domain/params/work_order_temp_local_params.dart';
import 'package:workorder_company_app/features/work_order/presentation/pages/work_order_assign_staffs_page.dart';
import 'package:workorder_company_app/features/work_order/presentation/pages/work_order_detail_page.dart';
import 'package:workorder_company_app/features/work_order/presentation/pages/work_order_fill_form_page.dart';
import 'package:workorder_company_app/features/work_order/presentation/pages/work_orders_list_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/routes/guards/route_guard.dart';

final workOrderRouter = [
  GoRoute(
    path: AppRoutes.workOrders,
    builder: (_, state) {
      final params = state.extra;
      if (params != null && params is WorkOrderTempLocalParams) {
        return WorkOrdersListPage(params: params);
      } else if (params is WorkOrderParams) {
        appLogger.i(params);
        return WorkOrdersListPage(
          filter: params,
        );
      }
      return WorkOrdersListPage();
    },
  ),
  GoRoute(
    path: AppRoutes.workOrdersAssignStaff,
    redirect: requireExtra<WorkOrderEntity>(),
    builder: (_, state) {
      final workOrder = state.extra as WorkOrderEntity;
      return WorkOrderAssignStaffsPage(workOrder: workOrder);
    },
  ),
  GoRoute(
    path: AppRoutes.workOrdersSubmission,
    redirect: requireExtra<WorkOrderEntity>(),
    builder: (_, state) {
      final workOrder = state.extra as WorkOrderEntity;
      return WorkOrderFillFormPage(workOrder: workOrder);
    },
  ),
  GoRoute(
    path: AppRoutes.workOrdersDetail,
    builder: (_, state) {
      return WorkOrderDetailPage(workOrderId: state.pathParameters['id']!);
    },
  ),
];
