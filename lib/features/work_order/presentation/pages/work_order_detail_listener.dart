import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/approval/approval_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/approval/approval_work_order_state.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/cancel/cancel_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/cancel/cancel_work_order_state.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/detail/work_order_detail_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/detail/work_order_detail_state.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/finalize/finalize_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/finalize/finalize_work_order_state.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/send/send_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/send/send_work_order_state.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';

class WorkOrderDetailListener extends StatelessWidget {
  final Widget child;

  const WorkOrderDetailListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _detailListener(),
        _sendListener(),
        _cancelListener(),
        _approvalListener(),
        _finalizeListener(),
      ],
      child: child,
    );
  }

  BlocListener _detailListener() {
    return BlocListener<WorkOrderDetailCubit, WorkOrderDetailState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == WorkOrderDetailStatus.error) {
          context.showError(state.errorMessage ?? "Terjadi kesalahan");
        }
      },
    );
  }

  BlocListener _cancelListener() {
    return BlocListener<CancelWorkOrderCubit, CancelWorkOrderState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == CancelWorkOrderStatus.error) {
          context.showError(state.errorMessage ?? "Terjadi kesalahan");
        }
        if (state.status == CancelWorkOrderStatus.success &&
            state.result != null) {
          context.read<WorkOrderDetailCubit>().updateResult(state.result!);
          context.showSuccess("Berhasil membatalkan perintah kerja");
        }
      },
    );
  }

  BlocListener _sendListener() {
    return BlocListener<SendWorkOrderCubit, SendWorkOrderState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == SendWorkOrderStatus.error) {
          context.showError(state.errorMessage ?? "Terjadi kesalahan");
        }

        if (state.status == SendWorkOrderStatus.success &&
            state.result != null) {
          context.read<WorkOrderDetailCubit>().updateResult(state.result!);
          context.showSuccess("Berhasil mengirim perintah kerja");
        }
      },
    );
  }

  BlocListener _approvalListener() {
    return BlocListener<ApprovalWorkOrderCubit, ApprovalWorkOrderState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == ApprovalWorkOrderStatus.error) {
          context.showError(state.errorMessage ?? "Terjadi kesalahan");
        }

        if (state.isSuccess && state.result != null) {
          context.read<WorkOrderDetailCubit>().updateResult(state.result!);

          context.showSuccess(
            state.isApproved
                ? "Berhasil menyetujui perintah kerja"
                : "Berhasil menolak perintah kerja",
          );
        }
      },
    );
  }

  BlocListener _finalizeListener() {
    return BlocListener<FinalizeWorkOrderCubit, FinalizeWorkOrderState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == FinalizeWorkOrderStatus.error) {
          context.showError(state.errorMessage ?? "Terjadi kesalahan");
        }

        if (state.isSuccess && state.result != null) {
          context.read<WorkOrderDetailCubit>().updateResult(state.result!);

          context.showSuccess(
            state.isComplete
                ? "Berhasil menyatakan perintah kerja selesai"
                : "Berhasil menyatakan perintah kerja gagal",
          );
        }
      },
    );
  }
}
