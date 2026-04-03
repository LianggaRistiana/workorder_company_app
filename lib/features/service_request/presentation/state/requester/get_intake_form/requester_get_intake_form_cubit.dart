import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/requester/requester_get_intake_form_usecase.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/get_intake_form/requester_get_intake_form_state.dart';

class RequesterGetIntakeFormCubit extends Cubit<RequesterGetIntakeFormState> {
  final RequesterGetIntakeFormUsecase getIntakeFormUsecase;

  RequesterGetIntakeFormCubit({
    required this.getIntakeFormUsecase,
  }) : super(const RequesterGetIntakeFormState());

  Future<void> getIntakeForm(String serviceId) async {
    emit(state.copyWith(status: RequesterGetIntakeFormStatus.loading, errorMessage: null));

    final result = await getIntakeFormUsecase(serviceId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: RequesterGetIntakeFormStatus.error,
        errorMessage: failure.message,
      )),
      (form) => emit(state.copyWith(
        status: RequesterGetIntakeFormStatus.loaded,
        form: form,
      )),
    );
  }
}
