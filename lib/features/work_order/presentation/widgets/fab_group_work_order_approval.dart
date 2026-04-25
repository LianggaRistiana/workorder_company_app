import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/features/work_order/domain/authorization/work_order_authorizer.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/meta/work_order_meta.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/approval/approval_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/approval/approval_work_order_state.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/fab_work_order_approve.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/fab_work_order_reject.dart';
import 'package:workorder_company_app/shared/widgets/loading_state_inline.dart';

class FabGroupWorkOrderApproval extends StatelessWidget {
  final WorkOrderEntity workOrder;
  final WorkOrderCapabilities? capabilities;

  const FabGroupWorkOrderApproval({
    super.key,
    required this.workOrder,
    this.capabilities,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApprovalWorkOrderCubit, ApprovalWorkOrderState>(
        builder: (context, state) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FabWorkOrderReject(onPressed: () {
            context
                .read<ApprovalWorkOrderCubit>()
                .rejectWorkOrder(workOrder, null);
          }).require(
            WorkOrderAuthorizer(
              workOrder: workOrder,
              capabilities: capabilities,
            ).rejectWorkOrder,
          ),
          SizedBox(width: 10),
          FabWorkOrderApprove(onPressed: () {
            context.read<ApprovalWorkOrderCubit>().approveWorkOrder(workOrder);
          }).require(
            WorkOrderAuthorizer(
              workOrder: workOrder,
              capabilities: capabilities,
            ).approveWorkOrder,
          ),
        ],
      ).withInlineLoading(state.status == ApprovalWorkOrderStatus.loading);
    });
  }
}
