import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/constants/app_enums/work_order_enum.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_radius.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/authorization/work_order_authorizer.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/detail/work_order_detail_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/detail/work_order_detail_state.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/fab_mapper.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/fab_work_order_sibling.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/work_order_status_step_card.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/adaptive_split_column.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/error_body.dart';
import 'package:workorder_company_app/shared/widgets/filled_form_view.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';
import 'package:workorder_company_app/shared/widgets/section_title.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/staff_quota_chip.dart';

class WorkOrderDetailPage extends StatelessWidget {
  final String workOrderId;
  const WorkOrderDetailPage({super.key, required this.workOrderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) =>
            sl<WorkOrderDetailCubit>()..getWorkOrderDetail(workOrderId),
        child: BlocConsumer<WorkOrderDetailCubit, WorkOrderDetailState>(
          listener: (context, state) {
            if (state.status == WorkOrderDetailStatus.error) {
              context.showError(state.errorMessage ?? "Terjadi kesalahan");
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(),
              body: _buildBody(state),
              floatingActionButton: state.workOrder != null
                  ? Builder(
                      builder: (_) {
                        final workOrder = state.workOrder!;
                        final mainFab = workOrder.status.buildFab(workOrder);
                        final sibling = state.workOrderSibling;

                        if (mainFab == null && sibling == null) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (sibling != null) ...[
                              FabWorkOrderSibling(siblings: sibling),
                              const SizedBox(height: 10),
                            ],
                            if (mainFab != null) mainFab,
                          ],
                        );
                      },
                    )
                  : null,
            );
          },
        ));
  }

  Widget _buildBody(WorkOrderDetailState state) {
    switch (state.status) {
      case WorkOrderDetailStatus.initial:
        return const SizedBox.shrink();

      case WorkOrderDetailStatus.loading:
        return const Center(child: AppLoading());

      case WorkOrderDetailStatus.error:
        return ErrorBody();

      case WorkOrderDetailStatus.loaded:
        final workOrder = state.workOrder;
        if (workOrder == null) {
          return const Center(child: Text("Tidak ada data yang tersedia"));
        }
        return _WorkOrderBody(workOrder: workOrder);
    }
  }
}

class _WorkOrderBody extends StatelessWidget {
  final WorkOrderEntity workOrder;
  const _WorkOrderBody({required this.workOrder});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
          onRefresh: () async {
            await context
                .read<WorkOrderDetailCubit>()
                .getWorkOrderDetail(workOrder.id);
          },
          child: AdaptiveSplitColumn(
            leftChildren: _leftChildren(context),
            rightChildren: _rightChildren(context),
          )),
    );
  }

  List<Widget> _leftChildren(BuildContext context) {
    return [
      CustomCard(
        child: PropertyDisplay(properties: [
          PropertyItem.text(
            icon: AppIcon.code,
            label: "Kode",
            value: workOrder.code,
          ),
          PropertyItem.text(
            icon: AppIcon.service,
            label: "Layanan",
            value: workOrder.service.title,
          ),
          PropertyItem.text(
              icon: AppIcon.user,
              label: "Dibuat oleh",
              value: workOrder.createdBy.name),
          PropertyItem.widget(
            icon: AppIcon.step,
            label: "Status",
            child: WorkOrderStatusStepCard(
                currentStatus: workOrder.status,
                statusDate: workOrder.statusDate),
          )
        ]),
      ),
      Row(
        children: [
          SectionTitle(
            "Pegawai Bertugas",
          ),
          const Spacer(),
          StaffQuotaChip(
            currentCount: workOrder.assignedStaffs.length,
            min: workOrder.minStaff,
            max: workOrder.maxStaff,
          )
        ],
      ),
      CustomCard(
        margin: EdgeInsets.all(0),
        child: CustomList(
          separatorHeight: 6,
          items: workOrder.assignedStaffs,
          itemBuilder: (item, index) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 18,
                child: Icon(
                  AppIcon.user,
                  size: AppRadius.medium,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    item.email,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
      Row(
        children: [
          const Spacer(),
          TextButton.icon(
              iconAlignment: IconAlignment.end,
              icon: Icon(AppIcon.next),
              onPressed: () {},
              label: Text("Edit Pegawai Bertugas"))
        ],
      ),
      const SizedBox(height: AppSpacing.md),
    ];
  }

  List<Widget> _rightChildren(BuildContext context) {
    return [
      SectionTitle(
        "Intruksi Perintah Kerja",
      ),
      FilledFormView(
        filledForm: FilledFormEntity(form: workOrder.workOrderForm.form),
      ),
      Row(
        children: [
          const Spacer(),
          TextButton.icon(
              iconAlignment: IconAlignment.end,
              icon: Icon(AppIcon.next),
              onPressed: () {},
              label: Text("Edit Instruksi Kerja"))
        ],
      ),
      const SizedBox(height: AppSpacing.lg),
      if (workOrder.status.isReportable)
        HorizontalButton(
          title: "Laporan Kerja",
          leadingIcon: AppIcon.workReport,
          description: "Lihat hasil pekerjaan oleh pegawai bertugas",
          onTap: () {},
        ),
      HorizontalButton(
              onTap: () {},
              isDanger: true,
              title: "Batalkan Perintah Kerja",
              description:
                  "Saat Perintah Kerja dibatalkan, semua perintah kerja terkait akan ikut dibatalkan",
              leadingIcon: AppIcon.cancel)
          .require(WorkOrderAuthorizer(workOrder: workOrder).cancelWorkOrder),
      const SizedBox(height: 100),
    ];
  }
}
