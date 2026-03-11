  import 'package:equatable/equatable.dart';
  import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

  enum PositionUpdateStatus { initial, loading, success, error }

  class PositionUpdateState extends Equatable {
    final PositionUpdateStatus status;
    final PositionEntity? updatedPosition;
    final String? errorMessage;

    const PositionUpdateState({
      this.status = PositionUpdateStatus.initial,
      this.updatedPosition,
      this.errorMessage,
    });

    PositionUpdateState copyWith({
      PositionUpdateStatus? status,
      PositionEntity? updatedPosition,
      String? errorMessage,
    }) {
      return PositionUpdateState(
        status: status ?? this.status,
        updatedPosition: updatedPosition ?? this.updatedPosition,
        errorMessage: errorMessage ?? this.errorMessage,
      );
    }

    @override
    List<Object?> get props => [status, updatedPosition, errorMessage];
  }
