import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_entity.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/domain/entities/option_entity.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:intl/intl.dart';

class FilledFormView extends StatelessWidget {
  final FilledFormEntity filledForm;

  const FilledFormView({super.key, required this.filledForm});

  // -------------------------------------------------------------
  // FIELD WRAPPER
  // -------------------------------------------------------------
  Widget _filledField(
    BuildContext context,
    FieldEntity field,
    dynamic answer,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          _answerWidget(context, field, answer),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // ANSWER WIDGET
  // -------------------------------------------------------------
  Widget _answerWidget(
      BuildContext context, FieldEntity field, dynamic answer) {
    switch (field.type) {
      case FieldType.text:
      case FieldType.textarea:
      case FieldType.time:
      case FieldType.number:
        if (answer == null || answer.toString().isEmpty) {
          return _textAnswer('-');
        }
        return _textAnswer(answer.toString());

      case FieldType.email:
        if (answer == null || answer.toString().isEmpty) {
          return _textAnswer('-');
        }
        return GestureDetector(
          onTap: () {},
          child: Text(
            answer.toString(),
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        );

      case FieldType.date:
        try {
          return _textAnswer(DateFormat('d MMMM yyyy', 'id_ID').format(answer));
        } catch (_) {
          return _textAnswer(answer.toString());
        }

      case FieldType.singleSelect:
        return _optionAnswer(context, field.options ?? [], [answer.toString()]);

      case FieldType.multiSelect:
        final listAnswer =
            (answer as List?)?.map((e) => e.toString()).toList() ?? [];
        return _optionAnswer(context, field.options ?? [], listAnswer);
    }
  }

  // -------------------------------------------------------------
  // TEXT ANSWER
  // -------------------------------------------------------------
  Widget _textAnswer(String answer) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        answer.isEmpty ? "-" : answer,
        style: const TextStyle(),
      ),
    );
  }

  // -------------------------------------------------------------
  // OPTION ANSWER (CHECKBOXES)
  // -------------------------------------------------------------
  Widget _optionAnswer(
    BuildContext context,
    List<OptionEntity> options,
    List<String> keyAnswer,
  ) {
    if (options.isEmpty) {
      return const Text("-");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options.map((opt) {
        final isSelected = keyAnswer.contains(opt.key);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                size: 20,
                color:
                    isSelected ? Theme.of(context).colorScheme.primary : null,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(opt.value)),
            ],
          ),
        );
      }).toList(),
    );
  }

  // -------------------------------------------------------------
  // FIND ANSWER BASED ON ORDER
  // -------------------------------------------------------------
  dynamic _findAnswer(String order) {
    final submission = filledForm.submission;
    if (submission == null || submission.fieldsData == null) {
      return null;
    }

    final matched = submission.fieldsData!.where((f) => f.order == order);

    return matched.isNotEmpty ? matched.first.value : null;
  }

  // -------------------------------------------------------------
  // BUILD WIDGET
  // -------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        const SizedBox(height: 8),
        CustomCard(
          child: Column(
            children: List.generate(
              filledForm.form.fields!.length,
              (index) {
                final field = filledForm.form.fields![index];

                return Column(
                  children: [
                    _filledField(
                      context,
                      field,
                      _findAnswer(field.order.toString()),
                    ),
                    if (index != filledForm.form.fields!.length - 1)
                      const Divider(height: 1),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
