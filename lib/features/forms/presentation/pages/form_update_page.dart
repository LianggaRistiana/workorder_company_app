import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/update/form_update_cubit.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/update/form_update_state.dart';
import 'package:workorder_company_app/features/forms/presentation/pages/form_editor_view.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';

class FormUpdatePage extends StatelessWidget {
  final FormEntity form;
  const FormUpdatePage({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FormUpdateCubit>(),
      child: BlocConsumer<FormUpdateCubit, FormUpdateState>(
          builder: (context, state) {
        return FormEditorView.update(
          initialEntity: form,
          isLoading: state.status == FormUpdateStatus.loading,
          onSubmit: context.read<FormUpdateCubit>().updateForm,
        );
      }, listener: (context, state) {
        if (state.status == FormUpdateStatus.error) {
          context.showError(state.errorMessage ?? "Terjadi Kesalahan");
        }
        if (state.status == FormUpdateStatus.success) {
          context.showSuccess("Berhasil memperbarui form");
          context.pop(state.updatedForm);
        }
      }),
    );
  }
}
