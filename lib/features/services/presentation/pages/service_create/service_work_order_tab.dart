import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

class ServiceWorkOrderTab extends StatelessWidget {
  const ServiceWorkOrderTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          InformationBlock.warning(
              "Layanan setidaknya memiliki satu perintah kerja"),
          const SizedBox(
            height: 12,
          ),
          DashedButton(
            title: "Tambah Tugas Kerja",
            onTap: () {},
            borderColor: Theme.of(context).disabledColor,
            color: Theme.of(context).colorScheme.primary,
            icon: Icons.add,
            height: 120,
            borderRadius: 16,
          ),
        ],
      ),
    );
  }
}
