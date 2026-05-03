import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/faq_doc_entity.dart';

class FaqDocModel extends FaqDocEntity {
  const FaqDocModel({
    required super.id,
    required super.title,
    required super.content,
    required super.type,
    required super.createdAt,
  });

  factory FaqDocModel.fromJson(Map<String, dynamic> json) {
    return FaqDocModel(
      id: json.field('id').reqString(),
      title: json.field('title').reqString(),
      content: json.field('content').reqString(),
      type: json.field('type').reqEnum(FaqDocsType.fromString),
      createdAt: json.field('createdAt').reqDate(),
    );
  }
}
