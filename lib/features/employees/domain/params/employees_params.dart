import 'package:equatable/equatable.dart';

class EmployeesParams extends Equatable {
  final String? positionId;
  final String? search;

  const EmployeesParams({
    this.positionId,
    this.search,
  });

  @override
  List<Object?> get props => [
        positionId,
        search,
      ];
}
