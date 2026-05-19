import 'package:equatable/equatable.dart';

class CompanyStatsEntity extends Equatable {
  final FormsStatEntity formsStat;
  final ServicesStatEntity servicesStat;
  final PositionsStatEntity positionsStat;
  final EmployeesStatEntity employeesStat;

  const CompanyStatsEntity({
    required this.formsStat,
    required this.servicesStat,
    required this.positionsStat,
    required this.employeesStat,
  });

  @override
  List<Object?> get props => [
        formsStat,
        servicesStat,
        positionsStat,
        employeesStat,
      ];
}

class FormsStatEntity extends Equatable {
  final int active;
  final int inActive;
  final int total;

  const FormsStatEntity({
    required this.active,
    required this.inActive,
    required this.total,
  });

  @override
  List<Object?> get props => [
        active,
        inActive,
        total,
      ];
}

class ServicesStatEntity extends Equatable {
  final int active;
  final int inActive;
  final int total;

  const ServicesStatEntity({
    required this.active,
    required this.inActive,
    required this.total,
  });

  @override
  List<Object?> get props => [
        active,
        inActive,
        total,
      ];
}

class PositionsStatEntity extends Equatable {
  final int active;
  final int inActive;
  final int total;

  const PositionsStatEntity({
    required this.active,
    required this.inActive,
    required this.total,
  });

  @override
  List<Object?> get props => [
        active,
        inActive,
        total,
      ];
}

class EmployeesStatEntity extends Equatable {
  final int total;
  final int managersCount;
  final int staffsCount;

  const EmployeesStatEntity({
    required this.total,
    required this.managersCount,
    required this.staffsCount,
  });

  @override
  List<Object?> get props => [
        total,
        managersCount,
        staffsCount,
      ];
}
