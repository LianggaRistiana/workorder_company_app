import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_entity.dart';
import 'package:workorder_company_app/features/work_report/presentation/widgets/fab_work_report_send.dart';
import 'package:workorder_company_app/features/work_report/presentation/widgets/fab_group_work_report_approval.dart';

extension FabWorkReportMapper on WorkReportStatus {
  Widget? buildFab(
    WorkOrderEntity workOrder,
    WorkReportEntity workReport,
  ) {
    return switch (this) {
      WorkReportStatus.onProgress => FabWorkReportSend(
          workOrder: workOrder,
          workReport: workReport,
        ),
      WorkReportStatus.sent => FabGroupWorkReportApproval(
          workOrder: workOrder,
          workReport: workReport,
        ),
      _ => null,
    };
  }
}
