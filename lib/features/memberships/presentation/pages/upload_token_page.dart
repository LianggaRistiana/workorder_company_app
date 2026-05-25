import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';

class UploadTokenPage extends StatefulWidget {
  const UploadTokenPage({super.key});

  @override
  State<UploadTokenPage> createState() => _UploadTokenPageState();
}

class _UploadTokenPageState extends State<UploadTokenPage> {
  File? _selectedFile;
  String? _fileName;
  bool _isLoading = false;

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

  Future<void> _uploadFile() async {
    if (_selectedFile == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: replace dengan API kamu
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("File berhasil diupload"),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Upload gagal: $e"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload File CSV'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Upload file CSV yang berisi token atau data yang akan diproses oleh sistem.",
            ),

            const SizedBox(height: 20),

            /// PICK FILE BUTTON
            DashedButton(
              icon: AppIcon.file,
              height: 120,
              title: _fileName ?? "Upload File CSV",
              borderColor: theme.colorScheme.primary,
              color: theme.colorScheme.primary,
              onTap: _pickCsvFile,
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
                      onPressed: _removeFile,
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
                onPressed:
                    _selectedFile == null || _isLoading ? null : _uploadFile,
                child: _isLoading
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
  }
}
