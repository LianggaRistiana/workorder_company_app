import 'package:workorder_company_app/shared/utils/string_case_utils.dart';

enum WorkReportStatus {
  onProgress,
  sent,
  approved,
  rejected,
  cancelled,
}

extension WorkReportStatusX on WorkReportStatus {
  String get toJsonString => name.toSnakeCase();
}
