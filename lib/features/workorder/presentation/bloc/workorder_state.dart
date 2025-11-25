part of 'workorder_bloc.dart';

enum WorkorderStateStatus {
  initial,
  loading,
  loaded,
  error,
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
  // TODO: implement props
  List<Object?> get props => [
        status,
        workorders,
        errorMessage,
      ];
}
