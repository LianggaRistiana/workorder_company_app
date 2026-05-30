// positions_list_state.dart
import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/params/position_params.dart';

enum PositionsListStatus { initial, loading, loaded, error }

class PositionsListState extends Equatable {
  final PositionsListStatus status;
  final List<PositionEntity> positions;
  final PositionParams params;
  final String? errorMessage;

  const PositionsListState({
    this.status = PositionsListStatus.initial,
    this.positions = const [],
    this.errorMessage,
    this.params = const PositionParams(),
  });

  List<PositionEntity> get filteredPositions {
    if (params.search == null || params.search!.trim().isEmpty) {
      return positions;
    }

    return positions
        .where(
          (position) => position.name.toLowerCase().contains(
                params.search!.trim().toLowerCase(),
              ),
        )
        .toList();
  }

  PositionsListState copyWith({
    PositionsListStatus? status,
    List<PositionEntity>? positions,
    String? errorMessage,
    PositionParams? params,
  }) {
    return PositionsListState(
      status: status ?? this.status,
      positions: positions ?? this.positions,
      errorMessage: errorMessage ?? this.errorMessage,
      params: params ?? this.params,
    );
  }

  @override
  List<Object?> get props => [
        status,
        positions,
        errorMessage,
        params,
      ];
}
