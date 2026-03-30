import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/create/form_create_cubit.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/create/form_create_state.dart';
import 'package:workorder_company_app/features/forms/presentation/pages/form_editor_view.dart';

class FormCreatePage extends StatelessWidget {
  const FormCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FormCreateCubit>(),
      child: BlocConsumer<FormCreateCubit, FormCreateState>(
          builder: (context, state) {
            return FormEditorView.create(
              isLoading: state.status == FormCreateStatus.loading,
              onSubmit: (draft) async {
                debugPrint("=== DRAFT RESULT ===");
                debugPrint(draft.toString());

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Submit ditekan (Dummy Mode)"),
                  ),
                );
              },
            );
          },
          listener: (context, state) {}),
    );
  }
}
