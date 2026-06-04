import 'package:workorder_company_app/core/result/result.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';

class PositionDetailMeta extends ResultMeta {
  final bool canDelete;

  const PositionDetailMeta({required this.canDelete});

  factory PositionDetailMeta.fromJson(Map<String, dynamic> json) {
    return PositionDetailMeta(
        canDelete: json.field("canDelete").optBool() ?? false);
  }
}
