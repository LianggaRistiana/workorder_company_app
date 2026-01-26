import 'package:workorder_company_app/features/submissions/domain/entitties/field_data_entity.dart';

class FieldDataModel extends FieldDataEntity {
  FieldDataModel({
    required super.order,
    required super.value,
  });

  factory FieldDataModel.fromJson(Map<String, dynamic> json) {
    return FieldDataModel(
      order: json['order'].toString(),
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order' : int.tryParse(order),
      // 'order': order,
      'value': value,
    };
  }
}
