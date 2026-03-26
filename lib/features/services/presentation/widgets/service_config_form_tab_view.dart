import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/core/utils/validators.dart';
import 'package:workorder_company_app/features/helps/presentation/widgets/help_button.dart';
import 'package:workorder_company_app/features/helps/presentation/widgets/service_type_tips.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/create/service_create_cubit.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/enum_selector.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_switch.dart';

// TODO : for support either add or edit service
class ServiceConfigFormTabView extends StatelessWidget {
  const ServiceConfigFormTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HorizontalSwitch(
              leadingIcon: AppIcon.activeState,
              title: "Layanan Aktif",
              description: "Layanan aktif akan langsung bisa digunakan",
              value: context.select((ServiceCreateCubit cubit) =>
                  cubit.state.serviceConfig.isActive),
              onChanged: context.read<ServiceCreateCubit>().toggleActive),
          CustomCard(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                CustomInputField(
                  prefixIcon: Icon(AppIcon.service),
                  label: "Nama Layanan",
                  validator: (value) =>
                      ValidatorUtils.required(value, fieldName: "Nama Layanan"),
                  onChanged: (p0) =>
                      context.read<ServiceCreateCubit>().updateTitle(p0),
                ),
                const SizedBox(height: 12),
                CustomInputField(
                    prefixIcon: Icon(AppIcon.desc),
                    label: "Deskripsi",
                    // controller: descController,
                    onChanged: (p0) => context
                        .read<ServiceCreateCubit>()
                        .updateDescription(p0),
                    maxLines: 3,
                    validator: (value) =>
                        ValidatorUtils.required(value, fieldName: "Deskripsi")),
                const SizedBox(height: 12),
                EnumSelector(
                    title: "Tipe Akses",
                    labelBuilder: (p0) => p0.displayName,
                    values: ServiceAccessType.values,
                    selectedValues: [
                      context.select((ServiceCreateCubit cubit) =>
                          cubit.state.serviceConfig.accessType)
                    ],
                    isMultiSelect: false,
                    onChanged: (value) {
                      context.read<ServiceCreateCubit>().updateAccessType(
                          value.firstOrNull ?? ServiceAccessType.internal);
                    }),
              ])),
          HelpButton(
            title: "Ketahui jenis akses layanan",
            child: ServiceAccessTypeTips(),
          ),
        ],
      ),
    );
  }
}
