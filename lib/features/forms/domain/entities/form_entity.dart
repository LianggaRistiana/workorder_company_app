import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

class FormEntity {
  final String id;
  final String title;
  final String description;
  // final String accessType;
  // final List<String> accessibleBy;
  // final List<PositionEntity>? allowedPositions;
  final List<FieldEntity>? fields;

  const FormEntity({
    required this.id,
    required this.title,
    required this.description,
    // required this.accessType,
    // required this.accessibleBy,
    // this.allowedPositions,
    this.fields,
  });
}
