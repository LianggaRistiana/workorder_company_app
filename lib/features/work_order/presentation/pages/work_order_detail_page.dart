import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/detail/work_order_detail_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/detail/work_order_detail_state.dart';
import 'package:workorder_company_app/features/work_order/presentation/pages/work_order_detail_body.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/fab_mapper.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/fab_work_order_sibling.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';
import 'package:workorder_company_app/shared/widgets/error_body.dart';

class WorkOrderDetailPage extends StatelessWidget {
  final String workOrderId;
  const WorkOrderDetailPage({super.key, required this.workOrderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) =>
            sl<WorkOrderDetailCubit>()..getWorkOrderDetail(workOrderId),
        child: BlocConsumer<WorkOrderDetailCubit, WorkOrderDetailState>(
          listener: (context, state) {
            if (state.status == WorkOrderDetailStatus.error) {
              context.showError(state.errorMessage ?? "Terjadi kesalahan");
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(),
              body: _buildBody(
                context,
                state,
              ),
              floatingActionButtonAnimator:
                  FloatingActionButtonAnimator.noAnimation,
              floatingActionButton: _buildFab(state),
            );
          },
        ));
  }

  Widget? _buildFab(WorkOrderDetailState state) {
    final workOrder = state.workOrder;
    if (workOrder == null) return null;

    final mainFab = workOrder.status.buildFab(workOrder);
    final sibling = state.workOrderSibling;

    if (mainFab == null && sibling == null) {
      return null;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (sibling != null) ...[
          FabWorkOrderSibling(siblings: sibling),
          const SizedBox(height: 10),
        ],
        if (mainFab != null) mainFab,
      ],
    );
  }

  Widget _buildBody(BuildContext context, WorkOrderDetailState state) {
    final workOrder = state.workOrder;

    if (workOrder != null) {
      return WorkOrderDetailBody(workOrder: workOrder);
    }

    switch (state.status) {
      case WorkOrderDetailStatus.loading:
        return const Center(child: AppLoading());

      case WorkOrderDetailStatus.error:
        return ErrorBody(
          errorMessage: state.errorMessage ?? "Terjadi kesalahan",
          onRetry: () {
            context
                .read<WorkOrderDetailCubit>()
                .getWorkOrderDetail(workOrderId);
          },
        );

      case WorkOrderDetailStatus.initial:
        return const SizedBox.shrink();

      case WorkOrderDetailStatus.loaded:
        return const Center(
          child: Text("Tidak ada data yang tersedia"),
        );
    }
  }
}
