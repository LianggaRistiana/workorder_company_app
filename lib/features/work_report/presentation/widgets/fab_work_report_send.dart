import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_report/domain/authorization/work_report_authorizer.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_entity.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/send/send_work_report_cubit.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/send/send_work_report_state.dart';
import 'package:workorder_company_app/shared/widgets/loading_state_inline.dart';

// TODO : add pop up confirmation

class FabWorkReportSend extends StatelessWidget {
  final WorkOrderEntity workOrder;
  final WorkReportEntity workReport;

  const FabWorkReportSend({
    super.key,
    required this.workOrder,
    required this.workReport,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SendWorkReportCubit, SendWorkReportState>(
        builder: (context, state) {
      return FloatingActionButton.extended(
        icon: Icon(AppIcon.send),
        onPressed: () {
          context.read<SendWorkReportCubit>().sendWorkReport(workReport);
        },
        label: Text('Final'),
      ).withInlineLoading(
        state.status == SendWorkReportStatus.loading,
      );
    }).require(
      WorkReportAuthorizer(
        workReport: workReport,
        workOrder: workOrder,
      ).sendWorkReport,
    );
  }
}
