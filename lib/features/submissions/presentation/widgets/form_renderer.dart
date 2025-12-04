import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/forms/domain/entities/ordered_form_entity.dart';
import 'field_renderer.dart';

class FormRenderer extends StatelessWidget {
  final List<OrderedFormEntity> orderedForms;
  final void Function(String formId, String order, dynamic value) onChanged;

  const FormRenderer({
    super.key,
    required this.orderedForms,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final orderedForm in orderedForms) ...[
          Text(
            orderedForm.form.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (orderedForm.form.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                orderedForm.form.description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          const SizedBox(height: 8),

          // Render fields
          for (final field in orderedForm.form.fields ?? [])
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: FieldRenderer(
                formId: orderedForm.form.id,
                field: field,
                onChanged: onChanged,
              ),
            ),

          const Divider(height: 32),
        ],
      ],
    );
  }
}
