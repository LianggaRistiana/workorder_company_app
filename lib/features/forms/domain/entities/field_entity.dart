import 'package:workorder_company_app/features/forms/domain/entities/option_entity.dart';

class FieldEntity {
  final int? order;
  final String label;
  final String type;
  final bool required;
  final String? placeholder;
  final int? min;
  final int? max;
  final List<OptionEntity>? options;

  const FieldEntity({
    this.order,
    required this.label,
    required this.type,
    required this.required,
    this.placeholder,
    this.min,
    this.max,
    this.options,
  });
}