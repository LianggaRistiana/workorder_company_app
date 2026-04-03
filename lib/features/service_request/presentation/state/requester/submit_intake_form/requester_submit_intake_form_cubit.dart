import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/requester/requester_submit_intake_form_usecase.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/submit_intake_form/requester_submit_intake_form_state.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';

class RequesterSubmitIntakeFormCubit extends Cubit<RequesterSubmitIntakeFormState> {
  final RequesterSubmitIntakeFormUsecase submitIntakeFormUsecase;

  RequesterSubmitIntakeFormCubit({
    required this.submitIntakeFormUsecase,
  }) : super(const RequesterSubmitIntakeFormState());

  Future<void> submitIntakeForm(String serviceId, SubmissionEntity submission) async {
    emit(state.copyWith(status: RequesterSubmitIntakeFormStatus.loading, errorMessage: null));

    final result = await submitIntakeFormUsecase(serviceId, submission);

    result.fold(
      (failure) => emit(state.copyWith(
        status: RequesterSubmitIntakeFormStatus.error,
        errorMessage: failure.message,
      )),
      (request) => emit(state.copyWith(
        status: RequesterSubmitIntakeFormStatus.success,
        request: request,
      )),
    );
  }
}
