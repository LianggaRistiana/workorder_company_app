import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_log_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/approval/approval_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/approval/approval_work_order_state.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/cancel/cancel_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/cancel/cancel_work_order_state.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/detail/work_order_detail_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/detail/work_order_detail_state.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/finalize/finalize_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/finalize/finalize_work_order_state.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/recreate/recreate_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/recreate/recreate_work_order_state.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/send/send_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/send/send_work_order_state.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/start/start_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/start/start_work_order_state.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';

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
        _startListener(),
        _finalizeListener(),
        _recreateListener(),
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
        if (state.status == WorkOrderDetailStatus.loaded) {
          context.read<NotificationLogCubit>().markAsRead(
                state.workOrder?.id,
                ResourceType.workOrder,
              );
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

  BlocListener _recreateListener() {
    return BlocListener<RecreateWorkOrderCubit, RecreateWorkOrderState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == RecreateWorkOrderStatus.error) {
          context.showError(state.errorMessage ?? "Terjadi kesalahan");
        }
        if (state.status == RecreateWorkOrderStatus.success &&
            state.result != null) {
          context.read<WorkOrderDetailCubit>().updateResult(state.result!);
          context.showSuccess("Berhasil membuat ulang perintah kerja");
          context.push(Endpoints.workorderDetail.fillId(state.result!.data.id));
        }
      },
    );
  }

  BlocListener _startListener() {
    return BlocListener<StartWorkOrderCubit, StartWorkOrderState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == StartWorkOrderStatus.error) {
          context.showError(state.errorMessage ?? "Terjadi kesalahan");
        }
        if (state.status == StartWorkOrderStatus.success &&
            state.result != null) {
          context.read<WorkOrderDetailCubit>().updateResult(state.result!);
          context.showSuccess("Berhasil memulai perintah kerja");
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
