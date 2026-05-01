import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/template_config/domain/entities/service_template_entity.dart';

class SelectedServiceTemplateDraft extends Equatable {
  final List<ServiceTemplateEntity> selectedServiceTemplate;

  const SelectedServiceTemplateDraft({
    required this.selectedServiceTemplate,
  });

  @override
  List<Object?> get props => [
        selectedServiceTemplate,
      ];
}
