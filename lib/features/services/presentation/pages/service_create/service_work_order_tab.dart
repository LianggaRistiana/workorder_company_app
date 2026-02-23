import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:logger/logger.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/forms_selector_container.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/add_service_cubit.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/service_config_state.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/work_order_config_item.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

class ServiceWorkOrderTab extends StatelessWidget {
  const ServiceWorkOrderTab({super.key});

  // bool _shouldRebuildDraft(
  //   ServiceWorkOrderConfigDraft prev,
  //   ServiceWorkOrderConfigDraft curr,
  // ) {
  //   return prev.workOrderForm != curr.workOrderForm ||
  //       prev.reportForm != curr.reportForm ||
  //       prev.departmentOnDuty != curr.departmentOnDuty ||
  //       prev.workOrderApprovalAccess != curr.workOrderApprovalAccess ||
  //       prev.workReportApprovalAccess != curr.workReportApprovalAccess;
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          // BlocBuilder<AddServiceCubit, ServiceConfigState>(
          //   buildWhen: (previous, current) {
          //     final prevItems = previous.serviceConfig.workOrderConfigs;
          //     final currItems = current.serviceConfig.workOrderConfigs;

          //     // Kalau jumlah item berubah → rebuild
          //     if (prevItems.length != currItems.length) return true;

          //     // Cek per item
          //     for (int i = 0; i < prevItems.length; i++) {
          //       if (_shouldRebuildDraft(prevItems[i], currItems[i])) {
          //         Logger().d("Rebuild draft");
          //         return true;
          //       }
          //     }

          //     Logger().d("not rebuild draft");
          //     // Kalau cuma min/max yang berubah → tidak rebuild
          //     return false;
          //   },
          //   builder: (context, state) {
          //     final items = state.serviceConfig.workOrderConfigs;

          //     return CustomList(
          //       scrollable: false,
          //       emptyWidget: InformationBlock.warning(
          //         "Layanan setidaknya memiliki satu perintah kerja",
          //       ),
          //       items: items,
          //       itemBuilder: (item, index) => WorkOrderConfigItem(
          //         key: ValueKey(item), // 🔥 penting
          //         draft: item,
          //         onDepartmentUpdate: (position) => context
          //             .read<AddServiceCubit>()
          //             .updateDepartmentOnDuty(position, index),
          //         onMinChange: (value) => context
          //             .read<AddServiceCubit>()
          //             .updateMinStaff(value, index),
          //         onMaxChange: (value) => context
          //             .read<AddServiceCubit>()
          //             .updateMaxStaff(value, index),
          //         onApprovalChange: (value) => context
          //             .read<AddServiceCubit>()
          //             .updateWorkOrderApprovalAccess(value, index),
          //         onRemove: () => context
          //             .read<AddServiceCubit>()
          //             .removeServiceWorkOrderConfig(index),
          //       ),
          //     );
          //   },
          // ),

          CustomList(
            scrollable: false,
            emptyWidget: InformationBlock.warning(
              "Layanan setidaknya memiliki satu perintah kerja",
            ),
            items: context.select((AddServiceCubit cubit) =>
                cubit.state.serviceConfig.workOrderConfigs),
            itemBuilder: (_, index) {
              return BlocSelector<AddServiceCubit, ServiceConfigState,
                  ServiceWorkOrderConfigDraft>(
                selector: (state) =>
                    state.serviceConfig.workOrderConfigs[index],
                builder: (context, draft) {
                  return WorkOrderConfigItem(
                    key: ValueKey(index),
                    draft: draft,
                    onDepartmentUpdate: (position) => context
                        .read<AddServiceCubit>()
                        .updateDepartmentOnDuty(position, index),
                    onMinChange: (value) => context
                        .read<AddServiceCubit>()
                        .updateMinStaff(value, index),
                    onMaxChange: (value) => context
                        .read<AddServiceCubit>()
                        .updateMaxStaff(value, index),
                    onApprovalChange: (value) => context
                        .read<AddServiceCubit>()
                        .updateWorkOrderApprovalAccess(value, index),
                    onRemove: () => context
                        .read<AddServiceCubit>()
                        .removeServiceWorkOrderConfig(index),
                  );
                },
              );
            },
          ),
          const SizedBox(
            height: 12,
          ),
          FormsSelectorContainer(
            selectedForms: [],
            onAdd: context.read<AddServiceCubit>().addWorkOrder,
            buttonBuilder: (context, onPressed, isLoading) => DashedButton(
              title: "Tambah Perintah Kerja",
              onTap: onPressed,
              borderColor: Theme.of(context).disabledColor,
              color: Theme.of(context).colorScheme.primary,
              icon: Icons.add,
              height: 120,
              borderRadius: 16,
              isLoading: isLoading,
            ),
          )
        ],
      ),
    );
  }
}
