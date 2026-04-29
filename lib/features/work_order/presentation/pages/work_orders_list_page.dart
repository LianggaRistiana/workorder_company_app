import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/helps/presentation/widgets/fab_help.dart';
import 'package:workorder_company_app/features/helps/presentation/widgets/work_order_tips.dart';
import 'package:workorder_company_app/features/work_order/domain/params/work_order_params.dart';
import 'package:workorder_company_app/features/work_order/domain/params/work_order_temp_local_params.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/create/work_order_create_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/list/work_orders_list_bloc.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/list/work_orders_list_event.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/list/work_orders_list_state.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/fab_work_order_create.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/work_order_filter_button.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/work_order_item_card.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';

class WorkOrdersListPage extends StatefulWidget {
  final WorkOrderTempLocalParams? params;
  final WorkOrderParams? filter;

  const WorkOrdersListPage({
    super.key,
    this.params,
    this.filter,
  });

  @override
  State<WorkOrdersListPage> createState() => _WorkOrdersListPageState();
}

class _WorkOrdersListPageState extends State<WorkOrdersListPage> {
  String? highlightServiceRequestId;
  bool isHighlighting = false;

  @override
  void initState() {
    super.initState();
    highlightServiceRequestId = widget.params?.byServiceRequestId;
  }

  void _triggerHighlight(WorkOrdersListState state) {
    final isExist = state.workOrders.any(
      (e) => e.serviceRequestId == highlightServiceRequestId,
    );

    if (!isExist) return;

    _blink();
  }

  Future<void> _blink() async {
    for (int i = 0; i < 4; i++) {
      if (!mounted) return;

      setState(() {
        isHighlighting = !isHighlighting;
      });

      await Future.delayed(const Duration(milliseconds: 500));
    }

    if (!mounted) return;

    setState(() {
      isHighlighting = false;
      highlightServiceRequestId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final params = widget.filter ??
        (highlightServiceRequestId == null
            ? WorkOrderParams.initialParams()
            : WorkOrderParams(
                status: [
                  WorkOrderStatus.drafted,
                  WorkOrderStatus.approved,
                ],
              ));

    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => sl<WorkOrdersListBloc>()
              ..add(GetWorkOrdersRequested(
                forceRefresh: highlightServiceRequestId != null,
              ))
              ..add(SetWorkOrderFilter(params)),
          ),
          BlocProvider(
            create: (_) => sl<WorkOrderCreateCubit>(),
          ),
        ],
        child: BlocConsumer<WorkOrdersListBloc, WorkOrdersListState>(
            listener: (context, state) {
          if (state.status == WorkOrdersListStatus.error) {
            context.showError(state.errorMessage ?? "Terjadi kesalahan");
          }

          if (state.status == WorkOrdersListStatus.loaded &&
              highlightServiceRequestId != null) {
            _triggerHighlight(state);
          }
        }, builder: (context, state) {
          final Color hithlightColor = Colors.yellow.withAlpha(40);

          return ListPageScaffold(
            title: "Perintah Kerja",
            isLoading: state.status == WorkOrdersListStatus.loading,
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FabHelp(
                  title: "Kenali Perintah Kerja",
                  child: WorkOrderTips(),
                ),
                const SizedBox(height: 10),
                FabWorkOrderCreate(),
              ],
            ),
            header: Row(
              children: [
                Spacer(),
                WorkOrderFilterButton(),
              ],
            ),
            items: state.workOrders,
            onRefresh: () async {
              context
                  .read<WorkOrdersListBloc>()
                  .add(GetWorkOrdersRequested(forceRefresh: true));
            },
            itemBuilder: (item) {
              final isTarget =
                  item.serviceRequestId == highlightServiceRequestId;

              return AnimatedContainer(
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 300),
                color: (isTarget && isHighlighting) ? hithlightColor : null,
                child: WorkOrderItemCard(
                  workOrder: item,
                  onTap: () {
                    context.push(AppRoutes.workOrdersDetail.fillId(item.id));
                  },
                ),
              );
            },
          );
        }));
  }
}
