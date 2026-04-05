import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/field_renderer.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';

class FormRenderer extends StatelessWidget {
  final FilledFormEntity filledForm;
  final void Function(String formId, String order, dynamic value) onChanged;

  const FormRenderer(
      {super.key, required this.filledForm, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomCard(
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.all(0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.all(4),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.center,
                    colors: [
                      Theme.of(context).colorScheme.primaryFixedDim,
                      Theme.of(context).colorScheme.primary,
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: const SizedBox(
                  height: 1,
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(filledForm.form.title,
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text(filledForm.form.description,
                            style: Theme.of(context).textTheme.bodyMedium),
                      ])),
            ])),
        const SizedBox(height: 16),
        CustomList<FieldEntity>(
          items: filledForm.form.fields ?? [],
          separatorHeight: 12,
          itemBuilder: (field, _) => FieldRenderer(
              formId: filledForm.form.id,
              field: field,
              onChanged: onChanged,
              value: filledForm.submission?.getFieldByOrder(field.order.toString())),
        ),
      ],
    );
  }
}
