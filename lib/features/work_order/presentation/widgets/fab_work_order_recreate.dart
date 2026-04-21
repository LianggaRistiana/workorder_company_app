import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/work_order/domain/authorization/work_order_authorizer.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/meta/work_order_meta.dart';

class FabWorkOrderRecreate extends StatelessWidget {
  final WorkOrderEntity workOrder;
  final WorkOrderCapabilities? capabilities;

  const FabWorkOrderRecreate(
      {super.key, required this.workOrder, required this.capabilities});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
            icon: Icon(AppIcon.recreate),
            onPressed: () {},
            label: Text('Buat Ulang'))
        .require(WorkOrderAuthorizer(
                workOrder: workOrder, capabilities: capabilities)
            .recreateWorkOrder);
  }
}
