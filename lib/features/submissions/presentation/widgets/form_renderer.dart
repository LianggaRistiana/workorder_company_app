import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/forms/domain/entities/ordered_form_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/field_data_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';
import 'field_renderer.dart';

class FormRenderer extends StatelessWidget {
  final List<OrderedFormEntity> orderedForms;
  final List<SubmissionEntity> submissions;
  final void Function(String formId, String order, dynamic value) onChanged;

  const FormRenderer({
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
    final lookup = buildFieldLookup();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final orderedForm in orderedForms) ...[
          // === FORM HEADER ===
          Text(
            orderedForm.form.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (orderedForm.form.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                orderedForm.form.description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),

          const SizedBox(height: 8),

          // === RENDER FIELDS ===
          for (final field in orderedForm.form.fields ?? [])
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: FieldRenderer(
                formId: orderedForm.form.id,
                field: field,
                onChanged: onChanged,
                value: lookup[orderedForm.form.id]?[field.order.toString()],
              ),
            ),

          const Divider(height: 32),
        ],
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:workorder_company_app/features/forms/domain/entities/ordered_form_entity.dart';
// import 'package:workorder_company_app/features/submissions/domain/entitties/field_data_entity.dart';
// import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';
// import 'field_renderer.dart';

// class FormRenderer extends StatelessWidget {
//   final List<OrderedFormEntity> orderedForms;
//   final List<SubmissionEntity> submissions;
//   final void Function(String formId, String order, dynamic value) onChanged;

//   const FormRenderer({
//     super.key,
//     required this.orderedForms,
//     required this.onChanged,
//     this.submissions = const [],
//   });

//   SubmissionEntity? getSubmissionByFormId(String formId) {
//     return submissions
//         .where((submission) => submission.formId == formId)
//         .firstOrNull;
//   }

//   FieldDataEntity? getFieldDataByFieldOrder(String formId, String order) {
//     final submission = getSubmissionByFormId(formId);
//     if (submission == null) return null;

//     return submission.fieldsData
//         ?.where((fieldData) => fieldData.order == order)
//         .firstOrNull;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         for (final orderedForm in orderedForms) ...[
//           Text(
//             orderedForm.form.title,
//             style: Theme.of(context).textTheme.titleLarge,
//           ),
//           if (orderedForm.form.description.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.only(bottom: 8.0),
//               child: Text(
//                 orderedForm.form.description,
//                 style: Theme.of(context).textTheme.bodySmall,
//               ),
//             ),
//           const SizedBox(height: 8),

//           // Render fields
//           for (final field in orderedForm.form.fields ?? [])
//             Padding(
//               padding: const EdgeInsets.only(bottom: 16),
//               child: FieldRenderer(
//                 formId: orderedForm.form.id,
//                 field: field,
//                 onChanged: onChanged,
//                 value: getFieldDataByFieldOrder(orderedForm.form.id, field.order.toString()),
//               ),
//             ),

//           const Divider(height: 32),
//         ],
//       ],
//     );
//   }
// }
