import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/forms/domain/entities/ordered_form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/usecases/public_get_service_form_usecase.dart';
import 'package:workorder_company_app/features/forms/domain/usecases/public_submit_intake_forms_usecase.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';

part 'submission_event.dart';
part 'submission_state.dart';

class SubmissionBloc extends Bloc<SubmissionEvent, SubmissionState> {
  final PublicGetServiceFormUsecase publicGetServiceFormUsecase;
  final PublicSubmitIntakeFormsUsecase publicSubmitIntakeFormsUsecase;

  SubmissionBloc({
    required this.publicGetServiceFormUsecase,
    required this.publicSubmitIntakeFormsUsecase,
  }) : super(IntialSubmissionState()) {
    on<FetchServiceForm>(_fetchServiceForm);
    on<SubmitIntakeForm>(_submitIntakeForm);
  }

  Future<void> _fetchServiceForm(
    FetchServiceForm event,
    Emitter<SubmissionState> emit,
  ) async {
    emit(Loading());

    final result = await publicGetServiceFormUsecase(event.serviceId);

    result.fold(
      (failure) => emit(Error(failure.message)),
      (form) => emit(ReadyToFill(form)),
    );
  }

  Future<void> _submitIntakeForm(
    SubmitIntakeForm event,
    Emitter<SubmissionState> emit,
  ) async {
    emit(Loading());

    final result = await publicSubmitIntakeFormsUsecase(
        event.serviceId, event.submissions);

    result.fold(
     (failure) => emit(Error(failure.message)),
      (_) => emit(Success()),
    );
  }
}
