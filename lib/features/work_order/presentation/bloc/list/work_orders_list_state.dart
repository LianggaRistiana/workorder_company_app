import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/params/work_order_params.dart';

enum WorkOrdersListStatus {
  initial,
  loading,
  loaded,
  error,
}

class WorkOrdersListState extends Equatable {
  final WorkOrdersListStatus status;
  final List<WorkOrderEntity> _workOrders;
  final WorkOrderParams filter;
  final String? errorMessage;

  const WorkOrdersListState({
    required this.status,
    required List<WorkOrderEntity> workOrders,
    required this.filter,
    this.errorMessage,
  }) : _workOrders = workOrders;

  /// Getter raw data (kalau memang perlu)
  List<WorkOrderEntity> get rawWorkOrders => _workOrders;

  /// Getter filtered data
  List<WorkOrderEntity> get workOrders {
    return _workOrders.where((wo) {
      //  Search filter
      final matchSearch = filter.search == null ||
          filter.search!.trim().isEmpty ||
          wo.code.toLowerCase().contains(filter.search!.toLowerCase());

      //  Status filter
      final matchStatus = filter.status == null ||
          filter.status!.isEmpty ||
          filter.status!.contains(wo.status);

      //  Position filter
      final matchPosition = filter.positionOnDuty == null ||
          wo.positionOnDuty.id == filter.positionOnDuty!.id;

      //  Service filter
      final matchService =
          filter.service == null || wo.service.id == filter.service!.id;

      final matchServiceRequest = filter.serviceRequest == null ||
          wo.serviceRequestId == filter.serviceRequest!.id;

      return matchSearch &&
          matchStatus &&
          matchPosition &&
          matchService &&
          matchServiceRequest;
    }).toList();
  }

  WorkOrdersListState copyWith({
    WorkOrdersListStatus? status,
    List<WorkOrderEntity>? workOrders,
    WorkOrderParams? filter,
    String? errorMessage,
  }) {
    return WorkOrdersListState(
      status: status ?? this.status,
      workOrders: workOrders ?? _workOrders,
      filter: filter ?? this.filter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        _workOrders,
        filter,
        errorMessage,
      ];
}