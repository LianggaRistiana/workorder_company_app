import 'package:workorder_company_app/core/result/result.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';

class FormDetailMeta extends ResultMeta {
  final bool canDelete;

  const FormDetailMeta({
    required this.canDelete,
  });

  factory FormDetailMeta.fromJson(Map<String, dynamic> json) {
    return FormDetailMeta(
      canDelete: json.field("canDelete").optBool() ?? false,
    );
  }
}
