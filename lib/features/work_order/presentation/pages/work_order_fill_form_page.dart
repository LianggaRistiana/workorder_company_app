import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/result/result.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_with_history_entity.dart';
import 'package:workorder_company_app/features/submissions/presentation/coordinator/form_renderer_coordinator.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/form_renderer.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/fill/fill_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/fill/fill_work_order_state.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/work_order_property_view.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/adaptive_split_column.dart';
import 'package:workorder_company_app/shared/widgets/button_with_loading_state.dart';

class WorkOrderFillFormPage extends StatefulWidget {
  final WorkOrderEntity workOrder;

  const WorkOrderFillFormPage({super.key, required this.workOrder});

  @override
  State<WorkOrderFillFormPage> createState() => _WorkOrderFillFormPageState();
}

class _WorkOrderFillFormPageState extends State<WorkOrderFillFormPage> {
  late final FormRendererCoordinator coordinator;

  @override
  void initState() {
    super.initState();
    coordinator = FormRendererCoordinator.filledForm(
        widget.workOrder.workOrderForm.currentFilledForm);
  }

  @override
  Widget build(BuildContext context) {
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
                  bottomNavigationBar: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: ButtonWithLoadingState(
                      onPressed: () {
                        context.read<FillWorkOrderCubit>().submitSubmission(
                              widget.workOrder,
                              coordinator.draft,
                            );
                      },
                      isLoading: state.status == FillWorkOrderStatus.loading,
                      icon: AppIcon.submit,
                      label: "Simpan",
                    ),
                  ).hideOnLargeScreen(),
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
      ButtonWithLoadingState(
        onPressed: () {
          context.read<FillWorkOrderCubit>().submitSubmission(
                widget.workOrder,
                coordinator.draft,
              );
        },
        isLoading: isLoading,
        icon: AppIcon.submit,
        label: "Simpan",
      ).hideOnSmallScreen(),
    ];
  }

  List<Widget> _formFill() {
    return [
      FormRenderer(coordinator: coordinator),
      const SizedBox(height: AppSpacing.md),
    ];
  }
}
