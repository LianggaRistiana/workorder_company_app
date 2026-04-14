import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/submissions/domain/draft/submisson_draft.dart';
import 'package:workorder_company_app/features/work_order/domain/draft/assigned_staffs_draft.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/assign_staffs_usecase.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/submit_work_order_submission_usecase.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/fill/fill_work_order_state.dart';

class FillWorkOrderCubit extends Cubit<FillWorkOrderState> {
  final SubmitWorkOrderSubmissionUseCase submitUsecase;
  final AssignStaffsUseCase assignStaffsUseCase;

  FillWorkOrderCubit({
    required this.submitUsecase,
    required this.assignStaffsUseCase,
  }) : super(FillWorkOrderState.initial());

  Future<void> assignStaffsToWorkOrder(
      WorkOrderEntity workOrder, AssignedStaffsDraft staffDraft) async {
    emit(state.copyWith(status: FillWorkOrderStatus.loading));
    final result = await assignStaffsUseCase(workOrder, staffDraft);
    result.fold(
      (failure) => emit(state.copyWith(
          status: FillWorkOrderStatus.error, errorMessage: failure.message)),
      (metaResult) => emit(state.copyWith(
          status: FillWorkOrderStatus.success, result: metaResult)),
    );
  }

    Future<void> submitSubmission(
      WorkOrderEntity workOrder, SubmissionDraft submission) async {
    emit(state.copyWith(status: FillWorkOrderStatus.loading));
    final result = await submitUsecase(workOrder, submission);
    result.fold(
      (failure) => emit(state.copyWith(
          status: FillWorkOrderStatus.error,
          errorMessage: failure.message)),
      (metaResult) => emit(state.copyWith(
          status: FillWorkOrderStatus.success,
          result: metaResult)),
    );
  }
}
