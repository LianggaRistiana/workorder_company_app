import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';
import 'package:workorder_company_app/features/services/data/model/service_model.dart';
import 'package:workorder_company_app/features/template_config/domain/entities/service_template_preview_entity.dart';

class ServiceTemplatePreviewModel extends ServiceTemplatePreviewEntity {
  const ServiceTemplatePreviewModel({
    required super.id,
    required super.service,
    required super.positionsRequired,
  });

  factory ServiceTemplatePreviewModel.fromJson(Map<String, dynamic> json) {
    return ServiceTemplatePreviewModel(
      id: json.field('_id').reqString(),
      service: json.field('service').reqModel(ServiceModel.fromJson),
      positionsRequired:
          json.field('positionsRequired').reqListModel(PositionModel.fromJson),
    );
  }
}
