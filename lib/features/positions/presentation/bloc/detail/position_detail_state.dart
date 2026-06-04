import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/domain/meta/position_detail_meta.dart';

enum PositionDetailStatus { initial, loading, error, loaded }

class PositionDetailState extends Equatable {
  final PositionDetailStatus status;
  final PositionEntity? position;
  final PositionDetailMeta? meta;
  final String? errorMessages;

  const PositionDetailState({
    this.status = PositionDetailStatus.initial,
    this.position,
    this.meta,
    this.errorMessages,
  });

  PositionDetailState copyWith(
      {PositionDetailStatus? status,
      PositionEntity? position,
      PositionDetailMeta? meta,
      String? errorMessages}) {
    return PositionDetailState(
        status: status ?? this.status,
        position: position ?? this.position,
        meta: meta ?? this.meta,
        errorMessages: errorMessages ?? this.errorMessages);
  }

  @override
  List<Object?> get props => [
        status,
        position,
        errorMessages,
        meta,
      ];
}
