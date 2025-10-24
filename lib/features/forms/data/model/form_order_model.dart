// import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
// import 'package:workorder_company_app/features/services/domain/entities/form_order_entity.dart';

// class FormOrderModel extends FormOrderEntity{

//    const FormOrderModel({
//     required super.order,
//     required super.form,
//   });

//   factory FormOrderModel.fromJson(Map<String, dynamic> json) {
//     return FormOrderModel(
//       order: json['order'] as int,
//       form: FormModel.fromJson(json['forms']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'order': order,
//       'formId': (form as FormModel).id,
//     };
//   }


//   factory FormOrderModel.fromEntity(FormOrderEntity entity) {
//     return FormOrderModel(
//       order: entity.order,
//       form: FormModel.fromEntity(entity.form),
//     );
//   }
// }
