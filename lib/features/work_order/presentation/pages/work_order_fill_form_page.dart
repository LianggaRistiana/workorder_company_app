import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/result/result.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_with_history_entity.dart';
import 'package:workorder_company_app/features/submissions/presentation/coordinator/form_renderer_coordinator.dart';
import 'package:workorder_company_app/features/submissions/presentation/cubit/file_upload_progress_cubit.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/form_renderer.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/fill/fill_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/fill/fill_work_order_state.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/work_order_property_view.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/adaptive_split_column.dart';
import 'package:workorder_company_app/shared/widgets/button_with_loading_state.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';

// TODO : Test this
class WorkOrderFillFormPage extends StatefulWidget {
  final WorkOrderEntity workOrder;

  const WorkOrderFillFormPage({super.key, required this.workOrder});

  @override
  State<WorkOrderFillFormPage> createState() => _WorkOrderFillFormPageState();
}

class _WorkOrderFillFormPageState extends State<WorkOrderFillFormPage> {
  late final FormRendererCoordinator? coordinator;

  @override
  void initState() {
    super.initState();

    final form = widget.workOrder.workOrderForm;

    if (form != null) {
      coordinator = FormRendererCoordinator.filledForm(
        form.currentFilledForm,
      );
    } else {
      coordinator = null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.showError(
            "Form perintah kerja tidak tersedia",
          );

          context.pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (coordinator == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: EmptyStateWidget(
            text: "Form perintah kerja tidak tersedia",
          ),
        ),
      );
    }

    return BlocProvider(
      create: (context) => sl<FillWorkOrderCubit>(),
      child: BlocConsumer<FillWorkOrderCubit, FillWorkOrderState>(
          listener: (context, state) {
            if (state.status == FillWorkOrderStatus.success) {
              context.showSuccess("Perintah Kerja berhasil disimpan");
              context.pop<Result<WorkOrderEntity>?>(state.result);
            }
            if (state.status == FillWorkOrderStatus.error) {
              context.showError(state.errorMessage ?? "Terjadi Kesalahan");
            }
          },
          builder: (context, state) => SafeArea(
                child: Scaffold(
                  appBar: AppBar(),
                  bottomNavigationBar: _buildSubmitButton(
                          context, state.status == FillWorkOrderStatus.loading)
                      .hideOnLargeScreen(),
                  body: AdaptiveSplitColumn(
                    leftChildren: _workOrderProps(
                        state.status == FillWorkOrderStatus.loading),
                    rightChildren: _formFill(),
                  ),
                ),
              )),
    );
  }

  List<Widget> _workOrderProps(bool isLoading) {
    return [
      WorkOrderPropertyView.shortView(workOrder: widget.workOrder),
      _buildSubmitButton(context, isLoading).hideOnSmallScreen(),
    ];
  }

  List<Widget> _formFill() {
    final coordinator = this.coordinator;
    if (coordinator == null) return [];

    return [
      FormRenderer(
          coordinator:
              coordinator), // FIXME : add Form Widget for validation here
      const SizedBox(height: AppSpacing.md),
    ];
  }

  Widget _buildSubmitButton(BuildContext context, bool isLoading) {
    final coordinator = this.coordinator;
    if (coordinator == null) return SizedBox.shrink();

    return ButtonWithLoadingState(
      onPressed: () {
        context.read<FillWorkOrderCubit>().submitSubmission(
              widget.workOrder,
              coordinator.draft,
            );
      },
      isLoading: isLoading,
      icon: AppIcon.submit,
      progress: context.watch<FileUploadProgressCubit>().state.totalProgress,
      loadingLabel:
          context.watch<FileUploadProgressCubit>().state.buttonMessage ??
              "Menyimpan...",
      label: "Simpan",
    );
  }
}
