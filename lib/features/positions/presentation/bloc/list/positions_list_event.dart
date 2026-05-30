import 'package:workorder_company_app/features/positions/params/position_params.dart';

sealed class PositionsListEvent {}

class GetPositionsListRequested extends PositionsListEvent {
  final bool forceRefresh;
  GetPositionsListRequested({this.forceRefresh = false});
}

class SetFilter extends PositionsListEvent {
  final PositionParams params;
  SetFilter(this.params);
}