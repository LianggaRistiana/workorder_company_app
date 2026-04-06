import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/has_form.dart';


// TODO[REPORT DONE FIRST] : remove this later
class OrderedFormEntity implements HasForm {
  @override
  final FormEntity form;
  final int order;

  const OrderedFormEntity({
    required this.form,
    required this.order,
  });

  OrderedFormEntity copyWith({
    FormEntity? form,
    int? order,
  }) {
    return OrderedFormEntity(
      form: form ?? this.form,
      order: order ?? this.order,
    );
  }
}
