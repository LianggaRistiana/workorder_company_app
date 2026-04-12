import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/assign_staffs_usecase.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/assign_staffs/assign_staffs_state.dart';
import 'package:workorder_company_app/features/work_order/domain/draft/assigned_staffs_draft.dart';

class AssignStaffsCubit extends Cubit<AssignStaffsState> {
  final AssignStaffsUseCase useCase;

  AssignStaffsCubit({required this.useCase})
      : super(AssignStaffsState.initial());

  Future<void> assignStaffsToWorkOrder(
      WorkOrderEntity workOrder, AssignedStaffsDraft staffDraft) async {
    emit(state.copyWith(status: AssignStaffsStatus.loading));
    final result = await useCase(workOrder, staffDraft);
    result.fold(
      (failure) => emit(state.copyWith(
          status: AssignStaffsStatus.error, errorMessage: failure.message)),
      (metaResult) => emit(state.copyWith(
          status: AssignStaffsStatus.success, workOrder: metaResult.data)),
    );
  }
}
