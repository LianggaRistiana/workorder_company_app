import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/presentation/pages/work_order_assign_staffs_page.dart';
import 'package:workorder_company_app/features/work_order/presentation/pages/work_order_detail_page.dart';
import 'package:workorder_company_app/features/work_order/presentation/pages/work_orders_list_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

final workOrderRouter = [
  GoRoute(
    path: AppRoutes.workOrders,
    builder: (_, __) => const WorkOrdersListPage(),
  ),
  GoRoute(
    path: AppRoutes.workOrdersAssignStaff,
    builder: (_, state) {
      final workOrder = state.extra as WorkOrderEntity;
      return WorkOrderAssignStaffsPage(workOrder: workOrder);
    },
  ),
  GoRoute(
    path: AppRoutes.workOrdersDetail,
    builder: (_, state) {
      return WorkOrderDetailPage(workOrderId: state.pathParameters['id']!);
    },
  ),
];
