import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/submit_work_order_submission_usecase.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/submit_submission/submit_work_order_submission_state.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';

class SubmitWorkOrderSubmissionCubit
    extends Cubit<SubmitWorkOrderSubmissionState> {
  final SubmitWorkOrderSubmissionUseCase useCase;

  SubmitWorkOrderSubmissionCubit({required this.useCase})
      : super(SubmitWorkOrderSubmissionState.initial());

  Future<void> submitSubmission(
      WorkOrderEntity workOrder, SubmissionEntity submission) async {
    emit(state.copyWith(status: SubmitWorkOrderSubmissionStatus.loading));
    final result = await useCase(workOrder, submission);
    result.fold(
      (failure) => emit(state.copyWith(
          status: SubmitWorkOrderSubmissionStatus.error,
          errorMessage: failure.message)),
      (metaResult) => emit(state.copyWith(
          status: SubmitWorkOrderSubmissionStatus.success,
          workOrder: metaResult.data)),
    );
  }
}
