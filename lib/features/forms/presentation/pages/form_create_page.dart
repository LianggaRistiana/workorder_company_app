import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/create/form_create_cubit.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/create/form_create_state.dart';
import 'package:workorder_company_app/features/forms/presentation/pages/form_editor_view.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';

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
          onSubmit: context.read<FormCreateCubit>().createForm,
        );
      }, listener: (context, state) {
        if (state.status == FormCreateStatus.error) {
          context.showError(state.errorMessage ?? "Terjadi Kesalahan");
        }
        if (state.status == FormCreateStatus.success) {
          context.showSuccess("Berhasil menambahkan form baru");
          context.pop();
        }
      }),
    );
  }
}
