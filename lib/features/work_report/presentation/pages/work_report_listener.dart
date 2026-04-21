import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/approval/approval_work_report_cubit.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/approval/approval_work_report_state.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/get/get_work_report_cubit.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/get/get_work_report_state.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/send/send_work_report_cubit.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/send/send_work_report_state.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';

class WorkReportListener extends StatelessWidget {
  final Widget child;
  const WorkReportListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _detailListener(),
        _sendListener(),
        _approvalListener(),
      ],
      child: child,
    );
  }

  BlocListener _detailListener() {
    return BlocListener<GetWorkReportCubit, GetWorkReportState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == GetWorkReportStatus.error) {
          context.showError(state.errorMessage ?? "Terjadi kesalahan");
        }
      },
    );
  }

  BlocListener _sendListener() {
    return BlocListener<SendWorkReportCubit, SendWorkReportState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == SendWorkReportStatus.error) {
          context.showError(state.errorMessage ?? "Terjadi kesalahan");
        }

        if (state.status == SendWorkReportStatus.success &&
            state.workReport != null) {
          context.read<GetWorkReportCubit>().updateResult(state.workReport!);
          context.showSuccess("Berhasil mengirim perintah kerja");
        }
      },
    );
  }

  BlocListener _approvalListener() {
    return BlocListener<ApprovalWorkReportCubit, ApprovalWorkReportState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == ApprovalWorkReportStatus.error) {
          context.showError(state.errorMessage ?? "Terjadi kesalahan");
        }

        if (state.isSuccess && state.workReport != null) {
          context.read<GetWorkReportCubit>().updateResult(state.workReport!);

          context.showSuccess(
            state.isApproved
                ? "Berhasil menyetujui laporan kerja"
                : "Berhasil menolak laporan kerja",
          );
        }
      },
    );
  }
}
