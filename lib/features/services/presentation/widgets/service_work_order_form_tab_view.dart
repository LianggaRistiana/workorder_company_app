import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:logger/logger.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/forms_selector_container.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/create/service_create_cubit.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/create/service_create_state.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/work_order_config_item.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

class ServiceWorkOrderFormTabView extends StatelessWidget {
  const ServiceWorkOrderFormTabView({super.key});

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
          CustomList(
            scrollable: false,
            emptyWidget: InformationBlock.warning(
              "Layanan setidaknya memiliki satu perintah kerja",
            ),
            items: context.select((ServiceCreateCubit cubit) =>
                cubit.state.serviceConfig.workOrderConfigs),
            itemBuilder: (_, index) {
              return BlocSelector<ServiceCreateCubit, ServiceCreateState,
                  ServiceWorkOrderConfigDraft>(
                selector: (state) =>
                    state.serviceConfig.workOrderConfigs[index],
                builder: (context, draft) {
                  return WorkOrderConfigItem(
                    key: ValueKey(index),
                    draft: draft,
                    onDepartmentUpdate: (position) => context
                        .read<ServiceCreateCubit>()
                        .updateDepartmentOnDuty(position, index),
                    onMinChange: (value) => context
                        .read<ServiceCreateCubit>()
                        .updateMinStaff(value, index),
                    onMaxChange: (value) => context
                        .read<ServiceCreateCubit>()
                        .updateMaxStaff(value, index),
                    onApprovalChange: (value) => context
                        .read<ServiceCreateCubit>()
                        .updateWorkOrderApprovalAccess(value, index),
                    onRemove: () => context
                        .read<ServiceCreateCubit>()
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
            onAdd: context.read<ServiceCreateCubit>().addWorkOrder,
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
