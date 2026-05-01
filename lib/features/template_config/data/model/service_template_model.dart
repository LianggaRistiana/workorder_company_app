import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/template_config/domain/entities/service_template_entity.dart';

class ServiceTemplateModel extends ServiceTemplateEntity {
  const ServiceTemplateModel({
    required super.id,
    required super.title,
    required super.desc,
  });

  factory ServiceTemplateModel.fromJson(Map<String, dynamic> json) {
    return ServiceTemplateModel(
      id: json.field('_id').reqString(),
      title: json.field('title').reqString(),
      desc: json.field('desc').reqString(),
    );
  }
}
