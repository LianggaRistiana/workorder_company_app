import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_radius.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/detail/work_order_detail_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/detail/work_order_detail_state.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/work_order_status_step_card.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/adaptive_split_column.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/error_body.dart';
import 'package:workorder_company_app/shared/widgets/filled_form_view.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';
import 'package:workorder_company_app/shared/widgets/section_title.dart';

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
            return Scaffold(appBar: AppBar(), body: _buildBody(state));
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
            leftChildren: _leftChildren(),
            rightChildren: _rightChildren(),
          )),
    );
  }

  List<Widget> _leftChildren() {
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
      SectionTitle(
        "Pegawai Bertugas",
      ),
      CustomCard(
        margin: EdgeInsets.all(0),
        child: CustomList(
            items: workOrder.assignedStaffs,
            itemBuilder: (item, index) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      child: Icon(
                        AppIcon.user,
                        size: AppRadius.medium,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(item.name),
                  ],
                )),
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
    ];
  }

  List<Widget> _rightChildren() {
    return [
      FilledFormView(
          filledForm: FilledFormEntity(form: workOrder.workOrderForm.form))
    ];
  }
}
