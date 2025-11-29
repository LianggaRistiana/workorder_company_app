part of 'workorder_bloc.dart';

enum WorkorderStateStatus {
  initial,
  loading,
  loaded,
  error,
}

class WorkorderDetailState extends Equatable {
  final WorkorderStateStatus status;
  final WorkorderEntity? workorder;
  final String? errorMessage;

  const WorkorderDetailState(
      {this.status = WorkorderStateStatus.initial,
      this.workorder,
      this.errorMessage});

  WorkorderDetailState copyWith({
    WorkorderStateStatus? status,
    WorkorderEntity? workorder,
    String? errorMessage,
  }) {
    return WorkorderDetailState(
      status: status ?? this.status,
      workorder: workorder ?? this.workorder,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        workorder,
        errorMessage,
      ];
}

class WorkorderState extends Equatable {
  final WorkorderStateStatus status;
  final List<WorkorderEntity> workorders;
  final String? errorMessage;

  const WorkorderState({
    this.status = WorkorderStateStatus.initial,
    this.workorders = const [],
    this.errorMessage,
  });

  WorkorderState copyWith({
    WorkorderStateStatus? status,
    List<WorkorderEntity>? workorders,
    String? errorMessage,
  }) {
    return WorkorderState(
      status: status ?? this.status,
      workorders: workorders ?? this.workorders,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        workorders,
        errorMessage,
      ];
}
