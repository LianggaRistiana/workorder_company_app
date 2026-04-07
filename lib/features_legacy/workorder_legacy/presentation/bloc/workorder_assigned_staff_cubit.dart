import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features_legacy/workorder_legacy/domain/usecases/set_assigned_staff_usecase.dart';
import 'package:workorder_company_app/features_legacy/workorder_legacy/presentation/bloc/workorder_bloc.dart';

class WorkorderAssignedStaffCubit extends Cubit<WorkorderStaffState> {
  final SetAssignedStaffUsecase setAssignedStaffUsecase;

  WorkorderAssignedStaffCubit(this.setAssignedStaffUsecase)
      : super(const WorkorderStaffState());

  Future<void> submitStaff(String workorderId) async {
    emit(state.copyWith(status: WorkorderStateStatus.loading));

    final data = await setAssignedStaffUsecase(workorderId, state.staffs);

    data.fold(
      (failure) => emit(state.copyWith(
          status: WorkorderStateStatus.error, errorMessage: failure.message)),
      (workorder) => emit(state.copyWith(status: WorkorderStateStatus.success)),
    );

    return Future.value();
  }

  Future<void> addInitialStaff(List<UserEntity> staffs) {
    emit(state.copyWith(staffs: staffs));
    return Future.value();
  }

  Future<void> addAssignStaff(UserEntity staff) {
    emit(state.copyWith(staffs: [...state.staffs, staff]));
    return Future.value();
  }

  Future<void> removeAssignStaff(UserEntity staff) {
    emit(state.copyWith(
        staffs: state.staffs.where((element) => element != staff).toList()));
    return Future.value();
  }
}
