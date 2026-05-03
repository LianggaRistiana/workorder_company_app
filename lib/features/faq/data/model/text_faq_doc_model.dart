import 'package:workorder_company_app/features/faq/domain/entitties/text_faq_doc_draft.dart';

class TextFaqDocModel extends TextFaqDocDraft {
  const TextFaqDocModel({
    required super.title,
    required super.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }

  factory TextFaqDocModel.fromDraft(TextFaqDocDraft draft) {
    return TextFaqDocModel(
      title: draft.title,
      content: draft.content,
    );
  }
}
