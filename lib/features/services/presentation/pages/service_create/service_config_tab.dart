import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/positions/presentation/widget/positions_selector_container.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';
import 'package:workorder_company_app/shared/widgets/enum_selector.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_switch.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

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
              description: "Layanan aktif akan langsung ditampilkan",
              value: false,
              onChanged: (_) {}),
          CustomInputField(
            label: "Judul Layanan",
            // controller: titleController,
            // validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            // validator: (value) =>
            //     ValidatorUtils.required(value, fieldName: "Judul Layanan")
          ),
          const SizedBox(height: 12),
          CustomInputField(
            label: "Deskripsi",
            // controller: descController,
            maxLines: 3,
            // validator: (value) =>
            //     ValidatorUtils.required(value, fieldName: "Deskripsi")
          ),
          const SizedBox(height: 12),
          // const Text('Tipe Akses',
          //     style: TextStyle(fontWeight: FontWeight.bold)),
          EnumSelector(
              title: "Tipe Akses",
              values: ServiceAccessType.values,
              selectedValues: [ServiceAccessType.internal],
              onChanged: (_) {}),
          InformationBlock(
              message:
                  "Tipe layanan menentukan layanan bisa diakses publik, langganan, atau hanya internal"),
          const SizedBox(height: 12),
          Text("Divisi Penyedia layanan",
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          PositionsSelectorContainer(
              selectedPositions: [],
              onAdd: (_) {},
              buttonBuilder: (context, onPressed, isLoading) => DashedButton(
                    title: "Pilih Divisi",
                    onTap: onPressed,
                    borderColor: Theme.of(context).disabledColor,
                    color: Theme.of(context).colorScheme.primary,
                    icon: isLoading ? Icons.hourglass_empty : Icons.add,
                    height: 60,
                    borderRadius: 12,
                  )),
        ],
      ),
    );
  }
}
