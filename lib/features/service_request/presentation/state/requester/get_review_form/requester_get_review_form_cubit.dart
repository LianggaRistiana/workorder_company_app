import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/requester/requester_get_review_form_usecase.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/get_review_form/requester_get_review_form_state.dart';

class RequesterGetReviewFormCubit extends Cubit<RequesterGetReviewFormState> {
  final RequesterGetReviewFormUsecase getReviewFormUsecase;

  RequesterGetReviewFormCubit({
    required this.getReviewFormUsecase,
  }) : super(const RequesterGetReviewFormState());

  Future<void> getReviewForm(String serviceRequestId) async {
    emit(state.copyWith(status: RequesterGetReviewFormStatus.loading, errorMessage: null));

    final result = await getReviewFormUsecase(serviceRequestId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: RequesterGetReviewFormStatus.error,
        errorMessage: failure.message,
      )),
      (form) => emit(state.copyWith(
        status: RequesterGetReviewFormStatus.loaded,
        form: form,
      )),
    );
  }
}
