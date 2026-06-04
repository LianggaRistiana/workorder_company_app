import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/utils/validators.dart';
import 'package:workorder_company_app/features/helps/presentation/widgets/form_type_tips.dart';
import 'package:workorder_company_app/features/helps/presentation/widgets/help_button.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/enum_selector.dart';

class FormConfigEditorTabView extends StatelessWidget {
  final GlobalKey<FormState>? formKey;
  final TextEditingController titleController;
  final TextEditingController descController;
  final FormType formType;
  final ValueChanged<FormType>? onFormTypeChanged;

  const FormConfigEditorTabView(
      {super.key,
      this.formKey,
      required this.titleController,
      required this.descController,
      this.onFormTypeChanged,
      required this.formType});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomInputField(
                    prefixIcon: Icon(AppIcon.form),
                    label: "Judul Formulir",
                    controller: titleController,
                    validator: (value) => ValidatorUtils.required(
                      value,
                      fieldName: "Judul",
                    ),
                  ),
                  const SizedBox(height: 18),
                  CustomInputField(
                    label: "Deskripsi Formulir",
                    prefixIcon: Icon(AppIcon.desc),
                    controller: descController,
                    maxLines: 3,
                    validator: (value) => ValidatorUtils.required(
                      value,
                      fieldName: "Deskripsi",
                    ),
                  ),
                  const SizedBox(height: 18),
                  EnumSelector<FormType>(
                      title: "Jenis Form",
                      values: FormType.values,
                      selectedValues: [formType],
                      isMultiSelect: false,
                      labelBuilder: (type) {
                        return type.displayName;
                      },
                      onChanged: (type) => onFormTypeChanged
                          ?.call(type.firstOrNull ?? FormType.workOrder)),
                ],
              ),
            ),
            HelpButton(
              title: "Ketahui Jenis Formulir",
              child: FormTypeTips(),
            )
          ],
        ),
      ),
    );
  }
}
