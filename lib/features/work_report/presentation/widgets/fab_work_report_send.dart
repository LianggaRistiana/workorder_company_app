import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_report/domain/authorization/work_report_authorizer.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_entity.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/send/send_work_report_cubit.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/send/send_work_report_state.dart';
import 'package:workorder_company_app/shared/widgets/app_dialog.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'package:workorder_company_app/shared/widgets/loading_state_inline.dart';

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
        onPressed: () => _showDialog(context),
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

  void _showDialog(BuildContext context) {
    showAppDialog(
      context,
      header: Row(
        children: [
          IconBox.small(icon: AppIcon.send),
          const SizedBox(width: 8),
          const Text("Finalisasi Laporan Kerja"),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InformationBlock.info(workReport.approvalAccess ==
                  WorkReportApprovalAccess.auto
              ? "Laporan kerja akan langsung disetujui karena pengaturan sistem otomatis. Laporan tidak akan bisa diperbarui setelah ini"
              : "Laporan kerja akan dikirim untuk ditinjau."),
        ],
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () => context.pop(),
            child: const Text("Batal"),
          ),
          FilledButton(
            onPressed: () {
              context.pop();
              context.read<SendWorkReportCubit>().sendWorkReport(workReport);
            },
            child: const Text("Kirim"),
          ),
        ],
      ),
    );
  }
}
