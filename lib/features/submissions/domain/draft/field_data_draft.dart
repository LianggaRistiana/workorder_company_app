import 'package:workorder_company_app/features/submissions/domain/entitties/field_data_entity.dart';

class FieldDataDraft {
  String order;
  dynamic value;

  FieldDataDraft({
    required this.order,
    this.value,
  });

  // Update value
  void updateValue(dynamic newValue) {
    value = newValue;
  }

  FieldDataEntity toEntity() {
    return FieldDataEntity(order: order, value: value);
  }
}
