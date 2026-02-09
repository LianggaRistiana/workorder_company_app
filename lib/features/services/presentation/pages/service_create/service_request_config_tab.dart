import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';

class ServiceRequestConfigTab extends StatelessWidget {
  const ServiceRequestConfigTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Formulir Pengajuan Layanan",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(
            height: 12,
          ),
          DashedButton(
            title: "Tambah Formulir",
            onTap: () {},
            borderColor: Theme.of(context).disabledColor,
            color: Theme.of(context).colorScheme.primary,
            icon: Icons.add,
            height: 120,
            borderRadius: 16,
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            "Formulir Review Layanan",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(
            height: 12,
          ),
          DashedButton(
            title: "Tambah Formulir Review",
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
