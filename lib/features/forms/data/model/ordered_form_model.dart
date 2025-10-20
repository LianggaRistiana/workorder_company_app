import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/forms/domain/entities/ordered_form_entity.dart';

class OrderedFormModel extends OrderedFormEntity {
  const OrderedFormModel({
    required super.form,
    required super.order,
  });

  factory OrderedFormModel.fromJson(Map<String, dynamic> json) {
    return OrderedFormModel(
      form: FormModel.fromJson(json["form"]),
      order: json["order"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "form": (form as FormModel).toJson(),
      "order": order,
    };
  }

  factory OrderedFormModel.fromEntity(OrderedFormEntity entity) {
    return OrderedFormModel(
      form: FormModel.fromEntity(entity.form),
      order: entity.order,
    );
  }
}
