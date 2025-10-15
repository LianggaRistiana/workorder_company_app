import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';

class FormEntity {
  final String id;
  final String title;
  final String description;
  final FormType formType;
  final List<FieldEntity>? fields;

  const FormEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.formType,
    this.fields,
  });
}
