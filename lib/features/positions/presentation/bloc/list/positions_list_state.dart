// positions_list_state.dart
import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

enum PositionsListStatus { initial, loading, loaded, error }

class PositionsListState extends Equatable {
  final PositionsListStatus status;
  final List<PositionEntity> positions;
  final String? errorMessage;

  const PositionsListState({
    this.status = PositionsListStatus.initial,
    this.positions = const [],
    this.errorMessage,
  });

  PositionsListState copyWith({
    PositionsListStatus? status,
    List<PositionEntity>? positions,
    String? errorMessage,
  }) {
    return PositionsListState(
      status: status ?? this.status,
      positions: positions ?? this.positions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, positions, errorMessage];
}
