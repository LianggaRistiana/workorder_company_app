import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';

class OrderedFormEntity {
  final FormEntity form;
  final int order;

  const OrderedFormEntity({
    required this.form,
    required this.order,
  });
}