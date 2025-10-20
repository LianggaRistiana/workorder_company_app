import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/forms/domain/entities/ordered_form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/usecases/public_get_service_form_usecase.dart';

part 'submission_event.dart';
part 'submission_state.dart';

class SubmissionBloc extends Bloc<SubmissionEvent, SubmissionState> {
  final PublicGetServiceFormUsecase publicGetServiceFormUsecase;

  SubmissionBloc({
    required this.publicGetServiceFormUsecase,
  }) : super(IntialSubmissionState()) {
    on<FetchServiceForm>(_fetchServiceForm);
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
}
