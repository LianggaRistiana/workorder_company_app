import 'package:workorder_company_app/features/faq/domain/entitties/pdf_faq_doc_draft.dart';

class PdfFaqDocModel extends PdfFaqDocDraft {
  PdfFaqDocModel({
    required super.title,
    required super.filePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'file': filePath,
    };
  }

  factory PdfFaqDocModel.fromDraft(PdfFaqDocDraft draft) {
    return PdfFaqDocModel(
      title: draft.title,
      filePath: draft.filePath,
    );
  }
}
