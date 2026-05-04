import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
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
      debugPrint("User cancel");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Unggah Berkas FaQ")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _filePath == null
              ? DashedButton(
                  borderColor: theme.colorScheme.primary,
                  color: theme.colorScheme.primary,
                  height: 200,
                  onTap: pickPdf,
                  title: "Pilih Berkas",
                  icon: AppIcon.file,
                )
              : Column(
                  children: [
                    _buildSelectedFile(theme),
                    const SizedBox(height: AppSpacing.md),
                    ButtonWithLoadingState(
                      icon: AppIcon.submit,
                      isLoading: false,
                      label: "Simpan",
                      onPressed: () {},
                    ),
                  ],
                ),
        ),
      ),
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
          OutlinedButton(
            onPressed: pickPdf,
            child: const Text("Ganti"),
          )
        ],
      ),
    );
  }
}
