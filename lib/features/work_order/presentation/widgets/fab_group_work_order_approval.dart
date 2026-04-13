import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/features/work_order/domain/authorization/work_order_authorizer.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/fab_work_order_approve.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/fab_work_order_reject.dart';

class FabGroupWorkOrderApproval extends StatelessWidget {
  final WorkOrderEntity workOrder;
  const FabGroupWorkOrderApproval({super.key, required this.workOrder});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FabWorkOrderReject(onPressed: () {}).require(
          WorkOrderAuthorizer(workOrder: workOrder).rejectWorkOrder,
        ),
        SizedBox(width: 10),
        FabWorkOrderApprove(onPressed: () {}).require(
          WorkOrderAuthorizer(workOrder: workOrder).approveWorkOrder,
        ),
      ],
    );
  }
}
