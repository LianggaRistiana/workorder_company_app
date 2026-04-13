import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/work_order/domain/authorization/work_order_authorizer.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';

class FabWorkOrderSend extends StatelessWidget {
  final WorkOrderEntity workOrder;

  const FabWorkOrderSend({super.key, required this.workOrder});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      icon: Icon(AppIcon.send),
      onPressed: () {},
      label: Text('Kirim'),
    ).require(
      WorkOrderAuthorizer(workOrder: workOrder).sendWorkOrder,
    );
  }
}
