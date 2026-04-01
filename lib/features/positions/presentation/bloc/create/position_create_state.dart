import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/error/failures.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

enum PositionCreateStatus { intial, loading, success, error }

class PositionCreateState extends Equatable {
  final PositionCreateStatus status;
  final PositionEntity? createdPosition;
  final Failure? failure;

  const PositionCreateState({
    this.status = PositionCreateStatus.intial,
    this.createdPosition,
    this.failure,
  });

  PositionCreateState copyWith({
    PositionCreateStatus? status,
    PositionEntity? createdPosition,
    Failure? failure,
  }) {
    return PositionCreateState(
      status: status ?? this.status,
      createdPosition: createdPosition ?? this.createdPosition,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, createdPosition, failure];
}
