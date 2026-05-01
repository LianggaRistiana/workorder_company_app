import 'package:workorder_company_app/features/template_config/domain/entities/selected_service_template_draft.dart';

class SelectedServiceTemplatePayloadModel extends SelectedServiceTemplateDraft {
  const SelectedServiceTemplatePayloadModel({
    required super.selectedServiceTemplate,
  });

  factory SelectedServiceTemplatePayloadModel.fromEntity(
      SelectedServiceTemplateDraft entity) {
    return SelectedServiceTemplatePayloadModel(
      selectedServiceTemplate: entity.selectedServiceTemplate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "serviceTemplateIds": selectedServiceTemplate.map((e) => e.id).toList(),
    };
  }
}
