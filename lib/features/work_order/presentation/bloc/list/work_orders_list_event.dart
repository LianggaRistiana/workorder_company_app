import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/work_order/domain/params/work_order_params.dart';

abstract class WorkOrdersListEvent extends Equatable {
  const WorkOrdersListEvent();

  @override
  List<Object?> get props => [];
}

class SetWorkOrderFilter extends WorkOrdersListEvent {
  final WorkOrderParams params;

  const SetWorkOrderFilter(this.params);

  @override
  List<Object?> get props => [params];
}

class GetWorkOrdersRequested extends WorkOrdersListEvent {
  final bool forceRefresh;

  const GetWorkOrdersRequested({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}
