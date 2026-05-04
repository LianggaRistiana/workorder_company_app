import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/upload_docs/upload_text_doc_cubit.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/upload_docs/upload_text_doc_state.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/button_with_loading_state.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';

class AddTextFaqDocPage extends StatelessWidget {
  const AddTextFaqDocPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UploadTextDocCubit>(),
      child: const _View(),
    );
  }
}

class _View extends StatefulWidget {
  const _View();

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<UploadTextDocCubit>().upload(
            _titleController.text,
            _contentController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UploadTextDocCubit, UploadTextDocState>(
      listener: (context, state) {
        if (state.status == UploadTextDocStatus.success) {
          context.showSuccess("Berhasil menambahkan dokumen");
          context.pop();
        } else if (state.status == UploadTextDocStatus.error) {
          context.showError(state.message ?? "Terjadi Kesalahan");
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.all(16),
              child: ButtonWithLoadingState(
                  icon: AppIcon.submit,
                  onPressed: _submit,
                  isLoading: state.status == UploadTextDocStatus.loading,
                  label: "Simpan"),
            ),
            body: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    CustomInputField(
                      label: "Judul",
                      controller: _titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Judul tidak boleh kosong";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    CustomInputField(
                      label: "Isi",
                      controller: _contentController,
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Judul tidak boleh kosong";
                        }
                        return null;
                      },
                    )
                  ],
                )),
              ),
            ),
          ),
        );
      },
    );
  }
}
