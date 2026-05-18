import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';

class FormPropertyView extends StatelessWidget {
  final FormEntity form;
  const FormPropertyView({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    final department = form.position;

    return CustomCard(
        child: PropertyDisplay(properties: [
      PropertyItem.text(
        label: 'Deskripsi',
        icon: Icons.info_outline,
        value: form.description,
      ),
      PropertyItem.text(
        label: 'Tipe Formulir',
        icon: Icons.category_outlined,
        value: form.formType.displayName,
      ),
      PropertyItem.text(
        label: 'Jumlah Pertanyaan',
        icon: Icons.question_mark_outlined,
        value: form.fields?.length.toString() ?? "-",
      ),
      if (department != null)
        PropertyItem.text(
          label: 'Departemen',
          icon: AppIcon.department,
          value: department.name,
        ),
    ]));
  }
}
