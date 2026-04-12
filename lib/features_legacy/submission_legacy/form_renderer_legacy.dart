import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/forms/domain/entities/ordered_form_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/field_data_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';

@Deprecated("Use Form Renderer instead")
class FormRendererLegacy extends StatelessWidget {
  final List<OrderedFormEntity> orderedForms;
  final List<SubmissionEntity> submissions;
  final void Function(String formId, String order, dynamic value) onChanged;
  // final

  const FormRendererLegacy({
    super.key,
    required this.orderedForms,
    required this.onChanged,
    this.submissions = const [],
  });

  Map<String, Map<String, FieldDataEntity>> buildFieldLookup() {
    final lookup = <String, Map<String, FieldDataEntity>>{};

    for (final submission in submissions) {
      final fields = submission.fieldsData;
      if (fields == null || fields.isEmpty) continue;

      final innerMap = lookup.putIfAbsent(submission.formId, () => {});

      for (final field in fields) {
        innerMap[field.order] = field; // O(1)
      }
    }

    return lookup;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
