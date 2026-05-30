import 'package:equatable/equatable.dart';

class EmployeesParams extends Equatable {
  final String? positionId;
  final String? search;

  const EmployeesParams({
    this.positionId,
    this.search,
  });

  EmployeesParams copyWith({
    Object? positionId = _sentinel,
    Object? search = _sentinel,
  }) {
    return EmployeesParams(
      positionId:
          positionId == _sentinel ? this.positionId : positionId as String?,
      search: search == _sentinel ? this.search : search as String?,
    );
  }

  static const _sentinel = Object();

  @override
  List<Object?> get props => [
        positionId,
        search,
      ];
}
