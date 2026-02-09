import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';

class ServiceWorkReportTab extends StatelessWidget {
  const ServiceWorkReportTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          DashedButton(
            title: "Tambah Laporan",
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
