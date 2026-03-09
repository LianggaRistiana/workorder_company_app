import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

enum PositionCreateStatus { intial, loading, success, error }

class PositionCreateState extends Equatable {
  final PositionCreateStatus status;
  final PositionEntity? createdPosition;
  final String? errorMessage;

  const PositionCreateState({
    this.status = PositionCreateStatus.intial,
    this.createdPosition,
    this.errorMessage,
  });

  PositionCreateState copyWith({
    PositionCreateStatus? status,
    PositionEntity? createdPosition,
    String? errorMessage,
  }) {
    return PositionCreateState(
      status: status ?? this.status,
      createdPosition: createdPosition ?? this.createdPosition,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, createdPosition, errorMessage];
}
