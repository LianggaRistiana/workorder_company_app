import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/forms_selector_container.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_switch_tile.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';
import 'package:workorder_company_app/shared/widgets/enum_selector.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

class ServiceRequestFormTabView extends StatelessWidget {
  final ServiceRequestApprovalAccess approvalAccess;
  final ValueChanged<ServiceRequestApprovalAccess> onApprovalAccessChanged;

  final FormEntity? intakeForm;
  final ValueChanged<FormEntity?> onIntakeFormChanged;

  final FormEntity? reviewForm;
  final ValueChanged<FormEntity?> onReviewFormChanged;

  final bool reviewNeed;
  final ValueChanged<bool> onReviewNeedChanged;

  const ServiceRequestFormTabView({
    super.key,
    required this.approvalAccess,
    required this.onApprovalAccessChanged,
    required this.intakeForm,
    required this.onIntakeFormChanged,
    required this.reviewForm,
    required this.onReviewFormChanged,
    required this.reviewNeed,
    required this.onReviewNeedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Approval Access
          CustomCard(
            child: EnumSelector<ServiceRequestApprovalAccess>(
              title: "Akses Persetujuan",
              isMultiSelect: false,
              values: ServiceRequestApprovalAccess.values,
              selectedValues: [approvalAccess],
              onChanged: (value) {
                if (value.isNotEmpty) {
                  onApprovalAccessChanged(value.first);
                }
              },
            ),
          ),

          const SizedBox(height: 24),

          /// Intake Form
          Text(
            "Formulir Permintaan Layanan",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),

          _FormSelectorSection(
            form: intakeForm,
            onTap: onIntakeFormChanged,
          ),

          const SizedBox(height: 24),

          /// Review Form
          Text(
            "Formulir ulasan Layanan",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),

          _FormSelectorSection(
            form: reviewForm,
            onTap: onReviewFormChanged,
          ),
          const SizedBox(height: 8),
          CustomSwitchTile(
            title: "Ulasan diperlukan",
            value: reviewNeed,
            onChanged: onReviewNeedChanged,
            description: "Ulasan diperlukan sebelum permintaan layanan ditutup",
          ),
        ],
      ),
    );
  }
}

class _FormSelectorSection extends StatelessWidget {
  final FormEntity? form;
  final ValueChanged<FormEntity?> onTap;

  const _FormSelectorSection({
    required this.form,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FormsSelectorContainer(
      selectedForms: form != null ? [form!] : [],
      onAdd: onTap,
      buttonBuilder: (context, onPressed, isLoading) {
        if (form != null) {
          return ClickableCustomCard(
            onTap: onPressed,
            child: Row(
              children: [
                IconBox(icon: Icons.assignment_turned_in_outlined),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    form!.title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                )
              ],
            ),
          );
        }

        return DashedButton(
          title: "Tambah Formulir",
          onTap: onPressed,
          borderColor: Theme.of(context).disabledColor,
          color: Theme.of(context).colorScheme.primary,
          icon: Icons.add,
          height: 120,
          borderRadius: 16,
          isLoading: isLoading,
        );
      },
    );
  }
}
