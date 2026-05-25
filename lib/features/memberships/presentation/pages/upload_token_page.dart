import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/upload_csv/upload_membership_csv_cubit.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/upload_csv/upload_membership_csv_state.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

class UploadTokenPage extends StatefulWidget {
  const UploadTokenPage({super.key});

  @override
  State<UploadTokenPage> createState() => _UploadTokenPageState();
}

class _UploadTokenPageState extends State<UploadTokenPage> {
  File? _selectedFile;
  String? _fileName;

  Future<void> _pickCsvFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: false,
    );

    if (result == null) return;

    final path = result.files.single.path;
    if (path == null) return;

    setState(() {
      _selectedFile = File(path);
      _fileName = result.files.single.name;
    });
  }

  void _uploadFile(BuildContext context) {
    if (_selectedFile == null) return;
    context.read<UploadMembershipCsvCubit>().upload(_selectedFile!.path);
  }

  void _removeFile() {
    setState(() {
      _selectedFile = null;
      _fileName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => sl<UploadMembershipCsvCubit>(),
      child: BlocConsumer<UploadMembershipCsvCubit, UploadMembershipCsvState>(
        listener: (context, state) {
          if (state.status == UploadMembershipCsvStatus.success) {
            context.showSuccess("Berkas berhasil diunggah");
            context.pop(state.membershipCodes);
          } else if (state.status == UploadMembershipCsvStatus.failure) {
            context.showError(
                state.errorMessage ?? "Terjadi kesalahan saat meunggah berkas");
          }
        },
        builder: (context, state) {
          final isLoading = state.status == UploadMembershipCsvStatus.loading;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Upload File CSV'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InformationBlock.info(
                      "Pastikan file CSV valid dengan mengikuti format berikut:"),
                  CsvSchemaInfo(),

                  const SizedBox(height: 20),

                  /// PICK FILE BUTTON
                  DashedButton(
                    icon: AppIcon.file,
                    height: 120,
                    title: _fileName ?? "Upload File CSV",
                    borderColor: theme.colorScheme.primary,
                    color: theme.colorScheme.primary,
                    onTap: isLoading ? null : _pickCsvFile,
                  ),

                  const SizedBox(height: 16),

                  /// FILE INFO CARD
                  if (_selectedFile != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.dividerColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.description),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _fileName ?? "-",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: isLoading ? null : _removeFile,
                            icon: const Icon(Icons.close),
                          )
                        ],
                      ),
                    ),

                  const Spacer(),

                  /// UPLOAD BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedFile == null || isLoading
                          ? null
                          : () => _uploadFile(context),
                      child: isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text("Upload"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CsvSchemaInfo extends StatelessWidget {
  const CsvSchemaInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final schema = const [
      ("external_customer_email", "EMAIL"),
      ("external_customer_name", "STRING"),
      ("token", "STRING"),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),

        /// TABLE STYLE
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              /// HEADER
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Text("Field",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ))),
                    SizedBox(width: 12),
                    Expanded(
                        child: Text("type",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ))),
                  ],
                ),
              ),

              /// ROWS
              ...schema.map((item) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: theme.dividerColor),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.$1,
                          style: const TextStyle(
                            fontFamily: "monospace",
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(item.$2),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Text(
          "Header CSV harus sesuai persis (case-sensitive)",
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
      ],
    );
  }
}
