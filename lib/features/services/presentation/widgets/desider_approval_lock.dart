import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';
import 'package:workorder_company_app/shared/widgets/section_title.dart';

class ConditionalApprovalSection extends StatelessWidget {
  final WorkOrderDraftingType type;
  final Widget child;
  const ConditionalApprovalSection({
    super.key,
    required this.type,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return type == WorkOrderDraftingType.manual
        ? child
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle("Akses Persetujuan"),
              CustomCard(
                  child: PropertyTitle(icon: AppIcon.lock, label: "Otomatis")),
            ],
          );
  }
}
