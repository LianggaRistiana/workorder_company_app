import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/requester/requester_submit_review_form_usecase.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/submit_review_form/requester_submit_review_form_state.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';

class RequesterSubmitReviewFormCubit extends Cubit<RequesterSubmitReviewFormState> {
  final RequesterSubmitReviewFormUsecase submitReviewFormUsecase;

  RequesterSubmitReviewFormCubit({
    required this.submitReviewFormUsecase,
  }) : super(const RequesterSubmitReviewFormState());

  Future<void> submitReviewForm(String serviceRequestId, SubmissionEntity submission) async {
    emit(state.copyWith(status: RequesterSubmitReviewFormStatus.loading, errorMessage: null));

    final result = await submitReviewFormUsecase(serviceRequestId, submission);

    result.fold(
      (failure) => emit(state.copyWith(
        status: RequesterSubmitReviewFormStatus.error,
        errorMessage: failure.message,
      )),
      (request) => emit(state.copyWith(
        status: RequesterSubmitReviewFormStatus.success,
        request: request,
      )),
    );
  }
}
