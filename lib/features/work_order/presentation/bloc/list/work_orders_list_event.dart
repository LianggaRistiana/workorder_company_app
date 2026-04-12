import 'package:equatable/equatable.dart';

abstract class WorkOrdersListEvent extends Equatable {
  const WorkOrdersListEvent();

  @override
  List<Object?> get props => [];
}

class GetWorkOrdersRequested extends WorkOrdersListEvent {
  final bool forceRefresh;

  const GetWorkOrdersRequested({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}
