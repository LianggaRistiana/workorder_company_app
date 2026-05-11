import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/dashboard/domain/entitties/company_stats_entity.dart';

class CompanyStatsModel extends CompanyStatsEntity {
  const CompanyStatsModel({
    required super.formsStat,
    required super.servicesStat,
    required super.positionsStat,
    required super.employeesStat,
  });

  factory CompanyStatsModel.fromJson(Map<String, dynamic> json) {
    return CompanyStatsModel(
      formsStat: json.field("forms_stat").reqModel(
            FormsStatModel.fromJson,
          ),
      servicesStat: json.field("services_stat").reqModel(
            ServicesStatModel.fromJson,
          ),
      positionsStat: json.field("positions_stat").reqModel(
            PositionsStatModel.fromJson,
          ),
      employeesStat: json.field("employees_stat").reqModel(
            EmployeesStatModel.fromJson,
          ),
    );
  }
}

class FormsStatModel extends FormsStatEntity {
  const FormsStatModel({
    required super.active,
    required super.inActive,
    required super.total,
  });

  factory FormsStatModel.fromJson(Map<String, dynamic> json) {
    return FormsStatModel(
      active: json.field("active").reqInt(),
      inActive: json.field("inActive").reqInt(),
      total: json.field("total").reqInt(),
    );
  }
}

class ServicesStatModel extends ServicesStatEntity {
  const ServicesStatModel({
    required super.active,
    required super.inActive,
    required super.total,
  });

  factory ServicesStatModel.fromJson(Map<String, dynamic> json) {
    return ServicesStatModel(
      active: json.field("active").reqInt(),
      inActive: json.field("inActive").reqInt(),
      total: json.field("total").reqInt(),
    );
  }
}

class PositionsStatModel extends PositionsStatEntity {
  const PositionsStatModel({
    required super.active,
    required super.inActive,
    required super.total,
  });

  factory PositionsStatModel.fromJson(Map<String, dynamic> json) {
    return PositionsStatModel(
      active: json.field("active").reqInt(),
      inActive: json.field("inActive").reqInt(),
      total: json.field("total").reqInt(),
    );
  }
}

class EmployeesStatModel extends EmployeesStatEntity {
  const EmployeesStatModel({
    required super.active,
    required super.inActive,
    required super.total,
    required super.managersCount,
    required super.staffsCount,
  });

  factory EmployeesStatModel.fromJson(Map<String, dynamic> json) {
    return EmployeesStatModel(
      active: json.field("active").reqInt(),
      inActive: json.field("inActive").reqInt(),
      total: json.field("total").reqInt(),
      managersCount: json.field("managers_count").reqInt(),
      staffsCount: json.field("staffs_count").reqInt(),
    );
  }
}
