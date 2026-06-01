import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_with_history_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/work_order_property_view.dart';
import 'package:workorder_company_app/features/work_report/domain/authorization/work_report_authorizer.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_entity.dart';
import 'package:workorder_company_app/features/work_report/presentation/pages/work_report_listener.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/approval/approval_work_report_cubit.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/get/get_work_report_cubit.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/get/get_work_report_state.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/send/send_work_report_cubit.dart';
import 'package:workorder_company_app/features/work_report/presentation/ui_mappers/fab_work_report_mapper.dart';
import 'package:workorder_company_app/features/work_report/presentation/widgets/work_report_property_view.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/adaptive_split_column.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/filled_form_view.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'package:workorder_company_app/shared/widgets/loading_state_inline.dart';

class WorkReportPage extends StatelessWidget {
  final WorkOrderEntity workOrder;
  const WorkReportPage({
    super.key,
    required this.workOrder,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<GetWorkReportCubit>()..getWorkReport(workOrder),
        ),
        BlocProvider(create: (context) => sl<SendWorkReportCubit>()),
        BlocProvider(create: (context) => sl<ApprovalWorkReportCubit>()),
      ],
      child: WorkReportListener(
        child: BlocBuilder<GetWorkReportCubit, GetWorkReportState>(
            builder: (context, state) {
          final workReport = state.workReport;

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              context.pop(state.shouldRefreshWorkOrder);
            },
            child: SafeArea(
                child: Scaffold(
              appBar: AppBar(),
              floatingActionButtonAnimator:
                  FloatingActionButtonAnimator.noAnimation,
              floatingActionButton: workReport?.status.buildFab(
                workOrder,
                workReport,
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  await context
                      .read<GetWorkReportCubit>()
                      .getWorkReport(workOrder);
                },
                child: _WorkReportBody(
                  workOrder: workOrder,
                  state: state,
                ),
              ),
            )),
          );
        }),
      ),
    );
  }
}

class _WorkReportBody extends StatelessWidget {
  final GetWorkReportState state;
  final WorkOrderEntity workOrder;
  const _WorkReportBody({
    required this.state,
    required this.workOrder,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveSplitColumn(
      leftChildren: _workOrderInfo(),
      rightChildren: _workReportInfo(context),
    );
  }

  List<Widget> _workOrderInfo() {
    return [
      WorkOrderPropertyView.shortView(workOrder: workOrder),
    ];
  }

  List<Widget> _workReportInfo(BuildContext context) {
    final workReport = state.workReport;

    if (workReport != null) {
      return [
        WorkReportPropertyView(report: workReport),
        const SizedBox(height: AppSpacing.md),
        if (workReport.showReportToRequester) ...[
          InformationBlock.info("Laporan ini akan ditampilkan ke pemohon"),
          const SizedBox(height: AppSpacing.sm),
        ],
        FilledFormView(
          filledForm: workReport.workReportForm.currentFilledForm,
        ),
        Row(
          children: [
            const Spacer(),
            TextButton.icon(
                iconAlignment: IconAlignment.end,
                icon: Icon(AppIcon.next),
                onPressed: () async {
                  final result = await context.push<WorkReportEntity?>(
                      AppRoutes.workReportSubmission,
                      extra: workReport);

                  if (result == null) return;
                  if (!context.mounted) return;

                  context.read<GetWorkReportCubit>().updateResult(result);
                },
                label: Text("Perbarui Laporan Kerja"))
          ],
        ).require(WorkReportAuthorizer(
          workReport: state.workReport!,
          workOrder: workOrder,
        ).fillWorkReport),
        const SizedBox(height: 100),
      ];
    }

    if (state.status == GetWorkReportStatus.loading) {
      return const [
        LoadingStateInline(
          isEndAlign: false,
        ),
        SizedBox(height: AppSpacing.md),
      ];
    }

    return [];
  }
}
