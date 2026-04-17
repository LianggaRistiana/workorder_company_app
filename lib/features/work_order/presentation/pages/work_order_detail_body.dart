import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/constants/app_enums/work_order_enum.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_radius.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/authorization/work_order_authorizer.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/cancel/cancel_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/cancel/cancel_work_order_state.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/detail/work_order_detail_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/work_order_status_step_card.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/adaptive_split_column.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/filled_form_view.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';
import 'package:workorder_company_app/shared/widgets/loading_state_inline.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';
import 'package:workorder_company_app/shared/widgets/section_title.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/staff_quota_chip.dart';

class WorkOrderDetailBody extends StatelessWidget {
  final WorkOrderEntity workOrder;
  const WorkOrderDetailBody({super.key, required this.workOrder});

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
              value: workOrder.createdBy?.name ?? 'Sistem'),
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
          if (workOrder.status.isNotStarted)
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
              onPressed: () {
                // context.push(AppRoutes.forbidden);
                context.push(AppRoutes.workOrdersAssignStaff, extra: workOrder);
              },
              label: Text("Edit Pegawai Bertugas"))
        ],
      ).require(WorkOrderAuthorizer(workOrder: workOrder).fillWorkOrder),
      const SizedBox(height: AppSpacing.md),
    ];
  }

  List<Widget> _rightChildren(BuildContext context) {
    return [
      SectionTitle(
        "Intruksi Perintah Kerja",
      ),
      FilledFormView(
        filledForm: FilledFormEntity(form: workOrder.workOrderForm.form, submission: workOrder.workOrderForm.submissionHistory?.firstOrNull),
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
      ).require(WorkOrderAuthorizer(workOrder: workOrder).fillWorkOrder),
      const SizedBox(height: AppSpacing.lg),
      if (workOrder.status.isReportable)
        HorizontalButton(
          title: "Laporan Kerja",
          leadingIcon: AppIcon.workReport,
          description: "Lihat hasil pekerjaan oleh pegawai bertugas",
          onTap: () {},
        ),
      BlocBuilder<CancelWorkOrderCubit, CancelWorkOrderState>(
          builder: (context, state) {
        return HorizontalButton(
                onTap: () {},
                isDanger: true,
                title: "Batalkan Perintah Kerja",
                description:
                    "Saat Perintah Kerja dibatalkan, semua perintah kerja terkait akan ikut dibatalkan",
                leadingIcon: AppIcon.cancel)
            .withInlineLoading(state.isLoading, isEndAlign: false);
      }).require(WorkOrderAuthorizer(workOrder: workOrder).cancelWorkOrder),
      const SizedBox(height: 100),
    ];
  }
}
