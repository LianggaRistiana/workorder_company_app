import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/presentation/pages/form_property_view.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/form_field_card.dart';
import 'package:workorder_company_app/features/helps/presentation/widgets/form_type_tips.dart';
import 'package:workorder_company_app/features/helps/presentation/widgets/help_button.dart';
import 'package:workorder_company_app/shared/widgets/header_of_page.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';

class FormPreviewPage extends StatelessWidget {
  final FormEntity form;
  const FormPreviewPage({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preview Formulir")),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            /// META DATA
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _formMetaData(form),
                ),
              ),
            ),

            /// HEADER FIELD SECTION
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              expandedHeight: 70,
              flexibleSpace: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: PropertyTitle(
                      label: "Daftar Pertanyaan",
                      icon: Icons.question_mark,
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.md),
            ),

            /// FIELDS (LAZY)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final field = form.fields![index];
                    return FormFieldCard(field: field);
                  },
                  childCount: form.fields?.length ?? 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _formMetaData(FormEntity form) {
    return [
      HeaderOfPage(title: form.title, icon: AppIcon.form),
      const SizedBox(height: AppSpacing.sm),
      FormPropertyView(form: form),
      HelpButton(title: "Kenali Tipe Formulir", child: FormTypeTips()),
      const SizedBox(height: AppSpacing.md),
    ];
  }
}
