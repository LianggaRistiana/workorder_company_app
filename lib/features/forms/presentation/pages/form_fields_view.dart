import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/form_field_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

class FormFieldsView extends StatelessWidget {
  final FormEntity form;

  const FormFieldsView({
    super.key,
    required this.form,
  });

  @override
  Widget build(BuildContext context) {
    return CustomList(
      items: form.fields ?? [],
      emptyFooterHeight: AppSpacing.lg,
      emptyWidget: InformationBlock.empty("Belum ada pertanyaan"),
      itemBuilder: (context, index) {
        final field = form.fields![index];
        return FormFieldCard(field: field);
      },
    );
  }
}
