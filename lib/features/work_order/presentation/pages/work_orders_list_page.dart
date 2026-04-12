import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/list/work_orders_list_bloc.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/list/work_orders_list_event.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/list/work_orders_list_state.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/work_order_item_card.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';

class WorkOrdersListPage extends StatelessWidget {
  const WorkOrdersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            sl<WorkOrdersListBloc>()..add(GetWorkOrdersRequested()),
        child: BlocConsumer<WorkOrdersListBloc, WorkOrdersListState>(
            listener: (context, state) {
          if (state.status == WorkOrdersListStatus.error) {
            context.showError(state.errorMessage ?? "Terjadi kesalahan");
          }
        }, builder: (context, state) {
          return ListPageScaffold(
            title: "Perintah Kerja",
            isLoading: state.status == WorkOrdersListStatus.loading,
            items: state.workOrders,
            onRefresh: () async {
              context
                  .read<WorkOrdersListBloc>()
                  .add(GetWorkOrdersRequested(forceRefresh: true));
            },
            itemBuilder: (item) => WorkOrderItemCard(
              workOrder: item,
              onTap: () {
                context.push(AppRoutes.workOrdersDetail.fillId(item.id));
              },
            ),
          );
        }));
  }
}
