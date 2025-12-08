part of 'workorder_bloc.dart';

enum WorkorderStateStatus { initial, loading, loaded, error, success }

class WorkorderSubmissionsState extends Equatable {
  final WorkorderStateStatus status;
  final String? errorMessage;

  const WorkorderSubmissionsState({
    this.status = WorkorderStateStatus.initial,
    this.errorMessage,
  });

  WorkorderSubmissionsState copyWith({
    WorkorderStateStatus? status,
    String? errorMessage,
  }) {
    return WorkorderSubmissionsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
      ];
}

class WorkorderStaffState extends Equatable {
  final WorkorderStateStatus status;
  final List<UserEntity> staffs;
  final String? errorMessage;

  const WorkorderStaffState(
      {this.status = WorkorderStateStatus.initial,
      this.staffs = const [],
      this.errorMessage});

  WorkorderStaffState copyWith({
    WorkorderStateStatus? status,
    List<UserEntity>? staffs,
    String? errorMessage,
  }) {
    return WorkorderStaffState(
      status: status ?? this.status,
      staffs: staffs ?? this.staffs,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  List<UserEntity> staffByPositionId(String positionId) {
    return staffs.where((staff) => staff.position?.id == positionId).toList();
  }

  @override
  List<Object?> get props => [
        status,
        staffs,
        errorMessage,
      ];
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
