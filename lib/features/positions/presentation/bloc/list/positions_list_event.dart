// positions_list_event.dart
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

sealed class PositionsListEvent {}

class GetPositionsListRequested extends PositionsListEvent {}

class NewPositionAdded extends PositionsListEvent {
  final PositionEntity position;
  NewPositionAdded(this.position);
}