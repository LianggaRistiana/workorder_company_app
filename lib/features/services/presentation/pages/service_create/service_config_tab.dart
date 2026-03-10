import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/core/utils/validators.dart';
import 'package:workorder_company_app/features/helps/presentation/widgets/help_button.dart';
import 'package:workorder_company_app/features/helps/presentation/widgets/service_type_tips.dart';
import 'package:workorder_company_app/features/positions/presentation/widget/positions_selector_container.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/add_service_cubit.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';
import 'package:workorder_company_app/shared/widgets/enum_selector.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_switch.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

class ServiceConfigTab extends StatelessWidget {
  const ServiceConfigTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HorizontalSwitch(
              leadingIcon: Icons.task_alt_sharp,
              title: "Layanan Aktif",
              description: "Layanan aktif akan langsung bisa digunakan",
              value: context.select((AddServiceCubit cubit) =>
                  cubit.state.serviceConfig.isActive),
              onChanged: context.read<AddServiceCubit>().toggleActive),
          CustomCard(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                CustomInputField(
                    prefixIcon: Icon(Icons.build_circle_outlined),
                    label: "Nama Layanan",
                    validator: (value) => ValidatorUtils.required(value,
                        fieldName: "Nama Layanan")),
                const SizedBox(height: 12),
                CustomInputField(
                    prefixIcon: Icon(Icons.info_outline),
                    label: "Deskripsi",
                    // controller: descController,
                    maxLines: 3,
                    validator: (value) =>
                        ValidatorUtils.required(value, fieldName: "Deskripsi")),
                const SizedBox(height: 12),
                EnumSelector(
                    title: "Tipe Akses",
                    labelBuilder: (p0) => p0.displayName,
                    values: ServiceAccessType.values,
                    selectedValues: [
                      context.select((AddServiceCubit cubit) =>
                          cubit.state.serviceConfig.accessType)
                    ],
                    isMultiSelect: false,
                    onChanged: (value) {
                      context.read<AddServiceCubit>().updateAccessType(
                          value.firstOrNull ?? ServiceAccessType.internal);
                    }),
              ])),
          HelpButton(
            title: "Ketahui jenis akses layanan",
            child: ServiceAccessTypeTips(),
          ),
          // const SizedBox(height: 12),
          Text("Department Penyedia layanan",
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          PositionsSelectorContainer(
              selectedPositions: context.select((AddServiceCubit cubit) =>
                  cubit.state.serviceConfig.departments),
              onAdd: context.read<AddServiceCubit>().addDepartment,
              buttonBuilder: (context, onPressed, isLoading) => DashedButton(
                    title: "Pilih Department",
                    onTap: onPressed,
                    borderColor: Theme.of(context).disabledColor,
                    color: Theme.of(context).colorScheme.primary,
                    icon: Icons.add,
                    height: 60,
                    borderRadius: 12,
                    isLoading: isLoading,
                  )),
          const SizedBox(height: 12),
          CustomList(
              emptyWidget: SizedBox.shrink(),
              separatorHeight: 8,
              items: context.select((AddServiceCubit cubit) =>
                  cubit.state.serviceConfig.departments),
              itemBuilder: (item, _) => CustomCard(
                  margin: const EdgeInsets.all(0),
                  child: Row(
                    children: [
                      IconBox(paddingSize: 8, icon: Icons.badge_outlined),
                      const SizedBox(width: 12),
                      Expanded(child: Text(item.name)),
                      IconButton(
                          onPressed: () =>
                              context.read<AddServiceCubit>().removeDepartment(
                                    item,
                                  ),
                          icon: const Icon(Icons.close))
                    ],
                  )))
        ],
      ),
    );
  }
}
