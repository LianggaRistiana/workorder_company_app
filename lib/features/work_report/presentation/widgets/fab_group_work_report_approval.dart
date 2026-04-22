import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/fab_work_order_approve.dart';
import 'package:workorder_company_app/features/work_report/domain/authorization/work_report_authorizer.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_entity.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/approval/approval_work_report_cubit.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/approval/approval_work_report_state.dart';
import 'package:workorder_company_app/features/work_report/presentation/widgets/fab_work_report_reject.dart';
import 'package:workorder_company_app/shared/widgets/loading_state_inline.dart';

class FabGroupWorkReportApproval extends StatelessWidget {
  final WorkOrderEntity workOrder;
  final WorkReportEntity workReport;

  const FabGroupWorkReportApproval({
    super.key,
    required this.workOrder,
    required this.workReport,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApprovalWorkReportCubit, ApprovalWorkReportState>(
        builder: (context, state) {
      return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        FabWorkReportReject(
          onPressed: () => context
              .read<ApprovalWorkReportCubit>()
              .rejectWorkReport(workReport),
        ).require(
          WorkReportAuthorizer(
            workReport: workReport,
            workOrder: workOrder,
          ).rejectWorkReport,
        ),
        SizedBox(width: 10),
        FabWorkOrderApprove(
          onPressed: () => context
              .read<ApprovalWorkReportCubit>()
              .approveWorkReport(workReport),
        ).require(
          WorkReportAuthorizer(
            workReport: workReport,
            workOrder: workOrder,
          ).approveWorkReport,
        ),
      ]).withInlineLoading(state.status == ApprovalWorkReportStatus.loading);
    });
  }
}
