import 'dart:io';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/pdf_item.dart';

class PdfViewerPage extends StatelessWidget {
  final PdfItem pdfItem;

  const PdfViewerPage({
    super.key,
    required this.pdfItem,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pdfItem.fileName)),
      body: pdfItem.isNetwork
          ? SfPdfViewer.network(pdfItem.filePath)
          : SfPdfViewer.file(File(pdfItem.filePath)),
    );
  }
}
