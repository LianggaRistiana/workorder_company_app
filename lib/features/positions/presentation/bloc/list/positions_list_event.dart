sealed class PositionsListEvent {}

class GetPositionsListRequested extends PositionsListEvent {
  final bool forceRefresh;
  GetPositionsListRequested({this.forceRefresh = false});
}

// class NewPositionAdded extends PositionsListEvent {
//   final PositionEntity position;
//   NewPositionAdded(this.position);
// }
