import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/features/work_order/domain/authorization/work_order_authorizer.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/meta/work_order_meta.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/finalize/finalize_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/finalize/finalize_work_order_state.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/fab_work_order_complete.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/fab_work_order_fail.dart';
import 'package:workorder_company_app/shared/widgets/loading_state_inline.dart';

class FabGroupWorkOrderFinalize extends StatelessWidget {
  final WorkOrderEntity workOrder;
  final WorkOrderCapabilities? capabilities;

  const FabGroupWorkOrderFinalize(
      {super.key, required this.workOrder, required this.capabilities});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinalizeWorkOrderCubit, FinalizeWorkOrderState>(
        builder: (context, state) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FabWorkOrderFail(onSubmit: (issue) {
            context
                .read<FinalizeWorkOrderCubit>()
                .failWorkOrder(workOrder, issue);
          }).require(
            WorkOrderAuthorizer(
                    workOrder: workOrder, capabilities: capabilities)
                .failWorkOrder,
          ),
          SizedBox(width: 10),
          FabWorkOrderComplete(onSubmit: (issue) {
            context
                .read<FinalizeWorkOrderCubit>()
                .completeWorkOrder(workOrder, issue);
          }).require(
            WorkOrderAuthorizer(
                    workOrder: workOrder, capabilities: capabilities)
                .completeWorkOrder,
          ),
        ],
      ).withInlineLoading(state.status == FinalizeWorkOrderStatus.loading);
    });
  }
}
