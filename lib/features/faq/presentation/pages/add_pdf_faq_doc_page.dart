import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/pdf_item.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/upload_docs/upload_pdf_doc_cubit.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/upload_docs/upload_pdf_doc_state.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/button_with_loading_state.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';

class AddPdfFaqDocPage extends StatefulWidget {
  const AddPdfFaqDocPage({super.key});

  @override
  State<AddPdfFaqDocPage> createState() => _AddPdfFaqDocPageState();
}

class _AddPdfFaqDocPageState extends State<AddPdfFaqDocPage> {
  String? _filePath;

  Future<void> pickPdf() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _filePath = result.files.single.path!;
      });
    } else {
      // debugPrint("User cancel");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UploadPdfDocCubit>(),
      child: BlocListener<UploadPdfDocCubit, UploadPdfDocState>(
        listener: (context, state) {
          if (state.isSuccess) {
            context.showSuccess("Berhasil menambahkan dokumen");
            context.pop();
          } else if (state.hasError) {
            context.showError(state.errorMessage ?? "Terjadi Kesalahan");
          }
        },
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(title: const Text("Unggah Berkas FaQ")),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _filePath == null
                    ? _buildPickButton(context)
                    : _buildContent(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        _buildSelectedFile(theme),
        const SizedBox(height: AppSpacing.md),
        BlocBuilder<UploadPdfDocCubit, UploadPdfDocState>(
          buildWhen: (prev, curr) =>
              prev.result?.progress != curr.result?.progress,
          builder: (context, state) {
            return ButtonWithLoadingState(
              icon: AppIcon.submit,
              isLoading: state.isUploading,
              progress: state.progress,
              label: "Simpan",
              loadingLabel: "Mengunggah Berkas",
              onPressed: state.isUploading
                  ? null
                  : () {
                      context.read<UploadPdfDocCubit>().uploadPdf(_filePath!);
                    },
            );
          },
        ),
      ],
    );
  }

  Widget _buildPickButton(BuildContext context) {
    final theme = Theme.of(context);

    return DashedButton(
      borderColor: theme.colorScheme.primary,
      color: theme.colorScheme.primary,
      height: 200,
      onTap: pickPdf,
      title: "Pilih Berkas",
      icon: AppIcon.file,
    );
  }

  Widget _buildSelectedFile(ThemeData theme) {
    final file = File(_filePath!);
    final fileName = file.path.split('/').last;
    final fileSize = file.lengthSync() / 1024; // KB

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.primary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            AppIcon.file,
            size: 48,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            fileName,
            style: const TextStyle(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            "${fileSize.toStringAsFixed(2)} KB",
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              OutlinedButton(
                onPressed: pickPdf,
                child: const Text("Ganti"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    debugPrint(_filePath);
                    context.push(
                      AppRoutes.previewPdf,
                      extra: PdfItem(
                        filePath: _filePath!,
                        fileName: fileName,
                        isNetwork: false,
                      ),
                    );
                  },
                  child: const Text("Lihat Berkas"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
