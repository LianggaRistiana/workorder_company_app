import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/presentation/pages/form_editor_view.dart';

class FormUpdatePage extends StatelessWidget {
  final FormEntity form;
  const FormUpdatePage({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return FormEditorView.update(
        isLoading: false,
        onSubmit: (draft) async {
          debugPrint("=== DRAFT RESULT ===");
          debugPrint(draft.toString());

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Submit ditekan (Dummy Mode)"),
            ),
          );
        },
        initialEntity: form);
  }
}
