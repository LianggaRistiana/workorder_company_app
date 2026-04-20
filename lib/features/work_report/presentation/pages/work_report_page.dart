import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_with_history_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/work_order_property_view.dart';
import 'package:workorder_company_app/features/work_report/presentation/pages/work_report_listener.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/approval/approval_work_report_cubit.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/get/get_work_report_cubit.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/get/get_work_report_state.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/send/send_work_report_cubit.dart';
import 'package:workorder_company_app/features/work_report/presentation/widgets/work_report_property_view.dart';
import 'package:workorder_company_app/shared/widgets/adaptive_split_column.dart';
import 'package:workorder_company_app/shared/widgets/filled_form_view.dart';
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
            builder: (context, state) => SafeArea(
                    child: Scaffold(
                  appBar: AppBar(),
                  body: RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<GetWorkReportCubit>()
                          .getWorkReport(workOrder);
                    },
                    child: _WorkReportBody(
                      workOrder: workOrder,
                      state: state,
                    ),
                  ),
                ))),
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
      rightChildren: _workReportInfo(),
    );
  }

  List<Widget> _workOrderInfo() {
    return [
      WorkOrderPropertyView.shortView(workOrder: workOrder),
      const SizedBox(height: AppSpacing.md),
    ];
  }

  List<Widget> _workReportInfo() {
    if (state.workReport != null) {
      return [
        WorkReportPropertyView(report: state.workReport!),
        const SizedBox(height: AppSpacing.md),
        FilledFormView(
          filledForm: state.workReport!.workReportForm.currentFilledForm,
        ),
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
