import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/services/domain/draft/service_work_order_config_draft.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/work_report_config_item.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

class ServiceWorkReportFormTabView extends StatelessWidget {
  final WorkOrderDraftingType draftingType;
  final List<ServiceWorkOrderConfigDraft> workOrders;

  final void Function(int index, WorkReportApprovalAccess value)
      onApprovalChange;

  final void Function(int index, FormEntity? form) onFormUpdate;

  const ServiceWorkReportFormTabView({
    super.key,
    required this.draftingType,
    required this.workOrders,
    required this.onApprovalChange,
    required this.onFormUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.md),
      child: CustomList(
        emptyWidget: InformationBlock.error(
          "Tambahkan Perintah Kerja terlebih dahulu sebelum konfigurasi laporan",
        ),
        items: workOrders,
        itemBuilder: (_, index) {
          final draft = workOrders[index];

          return WorkReportConfigItem(
            key: ValueKey(index),
            draftingType: draftingType,
            draft: draft,
            onApprovalChange: (value) => onApprovalChange(index, value),
            onFormUpdate: (form) => onFormUpdate(index, form),
          );
        },
      ),
    );
  }
}
