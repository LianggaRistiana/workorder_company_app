import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/work_order/presentation/pages/work_order_detail_page.dart';
import 'package:workorder_company_app/features/work_order/presentation/pages/work_orders_list_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

final workOrderRouter = [
  GoRoute(
    path: AppRoutes.workOrders,
    builder: (_, __) => const WorkOrdersListPage(),
  ),
  GoRoute(
    path: AppRoutes.workOrdersDetail,
    builder: (_, state) {
      return WorkOrderDetailPage(workOrderId: state.pathParameters['id']!);
    },
  ),
];
