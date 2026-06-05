import 'package:workorder_company_app/core/result/result.dart';

class EmployeeDetailMeta extends ResultMeta {
  final bool canKick;

  const EmployeeDetailMeta({
    required this.canKick,
  });

  factory EmployeeDetailMeta.fromJson(Map<String, dynamic> json) {
    return EmployeeDetailMeta(
      canKick: json['canKick'] ?? true,
    );
  }
}
