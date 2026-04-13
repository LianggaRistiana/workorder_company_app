import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/features/work_order/domain/authorization/work_order_authorizer.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/fab_work_order_complete.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/fab_work_order_fail.dart';

class FabGroupWorkOrderFinalize extends StatelessWidget {
  final WorkOrderEntity workOrder;
  const FabGroupWorkOrderFinalize({super.key, required this.workOrder});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FabWorkOrderFail(onPressed: () {}).require(
          WorkOrderAuthorizer(workOrder: workOrder).failWorkOrder,
        ),
        SizedBox(width: 10),
        FabWorkOrderComplete(onPressed: () {}).require(
          WorkOrderAuthorizer(workOrder: workOrder).completeWorkOrder,
        ),
      ],
    );
  }
}
