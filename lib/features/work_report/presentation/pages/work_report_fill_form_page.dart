import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums/work_report_enum.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_with_history_entity.dart';
import 'package:workorder_company_app/features/submissions/presentation/coordinator/form_renderer_coordinator.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/form_renderer.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_entity.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/submit/submit_work_report_submission_cubit.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/submit/submit_work_report_submission_state.dart';
import 'package:workorder_company_app/features/work_report/presentation/widgets/work_report_property_view.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/adaptive_split_column.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/shared/widgets/button_with_loading_state.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

class WorkReportFillFormPage extends StatefulWidget {
  final WorkReportEntity workReport;
  const WorkReportFillFormPage({
    super.key,
    required this.workReport,
  });

  @override
  State<WorkReportFillFormPage> createState() => _WorkReportFillFormPageState();
}

class _WorkReportFillFormPageState extends State<WorkReportFillFormPage> {
  late final FormRendererCoordinator coordinator;

  @override
  void initState() {
    super.initState();
    coordinator = FormRendererCoordinator.filledForm(
        widget.workReport.workReportForm.currentFilledForm);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SubmitWorkReportSubmissionCubit>(),
      child: BlocConsumer<SubmitWorkReportSubmissionCubit,
          SubmitWorkReportSubmissionState>(listener: (context, state) {
        if (state.status == SubmitWorkReportSubmissionStatus.error) {
          context.showError(state.errorMessage ?? "Terjadi kesalahan");
        }
        if (state.status == SubmitWorkReportSubmissionStatus.success) {
          context.showSuccess("Berhasil menyimpan laporan kerja");
          context.pop(state.workReport);
        }
      }, builder: (context, state) {
        return SafeArea(
            child: Scaffold(
          appBar: AppBar(),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
            ),
            child: ButtonWithLoadingState(
              onPressed: () {
                context
                    .read<SubmitWorkReportSubmissionCubit>()
                    .submitWorkReportSubmission(
                      widget.workReport,
                      coordinator.draft,
                    );
              },
              isLoading:
                  state.status == SubmitWorkReportSubmissionStatus.loading,
              icon: AppIcon.submit,
              label: "Simpan",
            ),
          ).hideOnLargeScreen(),
          body: AdaptiveSplitColumn(
            leftChildren: [
              if (!widget.workReport.status.isFinalReport) ...[
                InformationBlock.info(
                    "Selama belum difinalisasi, laporan merepresentasikan progres pengerjaan. Setelah difinalisasi, laporan bersifat final dan tidak dapat diubah."),
                const SizedBox(height: AppSpacing.md),
                WorkReportPropertyView(report: widget.workReport),
                ButtonWithLoadingState(
                  onPressed: () {
                    context
                        .read<SubmitWorkReportSubmissionCubit>()
                        .submitWorkReportSubmission(
                          widget.workReport,
                          coordinator.draft,
                        );
                  },
                  isLoading:
                      state.status == SubmitWorkReportSubmissionStatus.loading,
                  icon: AppIcon.submit,
                  label: "Simpan",
                ).hideOnSmallScreen()
              ]
            ],
            rightChildren: [
              FormRenderer(coordinator: coordinator),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ));
      }),
    );
  }
}
