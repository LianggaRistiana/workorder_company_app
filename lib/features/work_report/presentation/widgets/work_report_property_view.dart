import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_entity.dart';
import 'package:workorder_company_app/features/work_report/presentation/widgets/work_report_status_step_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';

class WorkReportPropertyView extends StatelessWidget {
  final WorkReportEntity report;

  const WorkReportPropertyView({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: PropertyDisplay(properties: [
        // if (report.approvedBy != null)
        PropertyItem.text(
          icon: AppIcon.user,
          label: "Disetujui oleh",
          value: report.approvedBy?.name ?? "Otomatis oleh Sistem",
        ),
        PropertyItem.widget(
          icon: AppIcon.step,
          label: "Status",
          child: WorkReportStatusStepCard(
            currentStatus: report.status,
            statusDate: report.statusDate, 
          ),
        ),
      ]),
    );
  }
}
