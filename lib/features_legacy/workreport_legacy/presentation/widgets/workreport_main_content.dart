import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/domain/entitties/work_report_entity.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/presentation/widgets/workreport_header.dart';
class WorkreportMainContent extends StatelessWidget {
  final WorkReportEntity? workReport;
  const WorkreportMainContent({super.key, this.workReport});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: [
          WorkreportHeader(),
          const SizedBox(
            height: 12,
          ),
          // if (workReport != null && workReport!.reportForms != null)
            // CustomList(
            //   scrollable: false,
            //   separatorHeight: 16,
            //   items: workReport!.reportForms!,
            //   itemBuilder: (item, _) => FilledFormView(filledForm: item),
            // ),
        ],
      ),
    );
  }
}
