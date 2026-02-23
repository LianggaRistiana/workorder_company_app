import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/forms_selector_container.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/service_config_state.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';
import 'package:workorder_company_app/shared/widgets/enum_selector.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

class WorkReportConfigItem extends StatelessWidget {
  final ServiceWorkOrderConfigDraft draft;
  final ValueChanged<WorkReportApprovalAccess> onApprovalChange;
  final ValueChanged<FormEntity> onFormUpdate;

  const WorkReportConfigItem({
    super.key,
    required this.draft,
    required this.onApprovalChange,
    required this.onFormUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconBox(icon: Icons.assignment_turned_in_outlined),
            const SizedBox(width: 12),
            Expanded(
                child: Text(
              draft.workOrderForm.title,
              style: Theme.of(context).textTheme.titleMedium,
            ))
          ],
        ),
        const SizedBox(height: 12),
        EnumSelector(
            isMultiSelect: false,
            title: "Akses Persetujuan laporan",
            values: WorkReportApprovalAccess.values,
            selectedValues: [draft.workReportApprovalAccess],
            onChanged: (value) {
              if (value.isNotEmpty) {
                onApprovalChange(value.first);
              }
            }),
        const SizedBox(height: 16),
        Text(
          "Formulir Laporan",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        FormsSelectorContainer(
            selectedForms: draft.reportForm != null ? [draft.reportForm!] : [],
            onAdd: onFormUpdate,
            buttonBuilder: (context, onPressed, isLoading) {
              if (isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (draft.reportForm != null) {
                return ClickableCustomCard(
                  margin: EdgeInsets.all(0),
                  onTap: onPressed,
                  child: Row(children: [
                    const IconBox(icon: Icons.assignment_outlined),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        draft.reportForm!.title,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    )
                  ]),
                );
              }

              return DashedButton(
                title: "Pilih Formulir Laporan",
                onTap: onPressed,
                borderColor: Theme.of(context).disabledColor,
                color: Theme.of(context).colorScheme.primary,
                icon: Icons.add,
                height: 60,
                borderRadius: 12,
                isLoading: isLoading,
              );
            }),
      ],
    ));
  }
}
