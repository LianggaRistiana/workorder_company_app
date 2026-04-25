import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/meta/work_order_meta.dart';

import 'package:workorder_company_app/features/work_order/presentation/widgets/fab_group_work_order_approval.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/fab_group_work_order_finalize.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/fab_work_order_recreate.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/fab_work_order_send.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/fab_work_order_start.dart';

extension WorkOrderFabMapper on WorkOrderStatus {
  Widget? buildFab(
    WorkOrderEntity workOrder,
    WorkOrderCapabilities? capabilities,
  ) {
    return switch (this) {
      WorkOrderStatus.drafted => FabWorkOrderSend(
          workOrder: workOrder,
          capabilities: capabilities,
        ),
      WorkOrderStatus.sent => FabGroupWorkOrderApproval(
          workOrder: workOrder,
          capabilities: capabilities,
        ),
      WorkOrderStatus.approved => FabWorkOrderStart(
          workOrder: workOrder,
          capabilities: capabilities,
        ),
      WorkOrderStatus.onProgress => FabGroupWorkOrderFinalize(
          workOrder: workOrder,
          capabilities: capabilities,
        ),
      WorkOrderStatus.rejected => FabWorkOrderRecreate(
          workOrder: workOrder,
          capabilities: capabilities,
        ),
      _ => null,
    };
  }
}
