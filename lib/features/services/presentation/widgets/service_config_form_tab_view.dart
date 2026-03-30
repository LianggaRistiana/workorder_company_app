import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/core/utils/validators.dart';
import 'package:workorder_company_app/features/helps/presentation/widgets/help_button.dart';
import 'package:workorder_company_app/features/helps/presentation/widgets/service_type_tips.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/enum_selector.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_switch.dart';
class ServiceConfigFormTabView extends StatelessWidget {
  final bool isActive;
  final bool isUpdate;
  final ValueChanged<bool> onActiveChanged;

  final TextEditingController titleController;
  final TextEditingController descriptionController;

  final ServiceAccessType accessType;
  final ValueChanged<ServiceAccessType> onAccessTypeChanged;

  const ServiceConfigFormTabView({
    super.key,
    required this.isUpdate,
    required this.isActive,
    required this.onActiveChanged,
    required this.titleController,
    required this.descriptionController,
    required this.accessType,
    required this.onAccessTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUpdate)
          HorizontalSwitch(
            leadingIcon: AppIcon.activeState,
            title: "Layanan Aktif",
            description: "Layanan aktif akan langsung bisa digunakan",
            value: isActive,
            onChanged: onActiveChanged,
          ),

          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomInputField(
                  controller: titleController, 
                  prefixIcon: Icon(AppIcon.service),
                  label: "Nama Layanan",
                  validator: (value) =>
                      ValidatorUtils.required(
                        value,
                        fieldName: "Nama Layanan",
                      ),
                ),

                const SizedBox(height: 12),

                CustomInputField(
                  controller: descriptionController,
                  prefixIcon: Icon(AppIcon.desc),
                  label: "Deskripsi",
                  maxLines: 3,
                  validator: (value) =>
                      ValidatorUtils.required(
                        value,
                        fieldName: "Deskripsi",
                      ),
                ),

                const SizedBox(height: 12),

                EnumSelector<ServiceAccessType>(
                  title: "Tipe Akses",
                  labelBuilder: (e) => e.displayName,
                  values: ServiceAccessType.values,
                  selectedValues: [accessType],
                  isMultiSelect: false,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      onAccessTypeChanged(value.first);
                    }
                  },
                ),
              ],
            ),
          ),

          HelpButton(
            title: "Ketahui jenis akses layanan",
            child: ServiceAccessTypeTips(),
          ),
        ],
      ),
    );
  }
}