import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/usecases/get_form_byid_usecase.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/detail/form_detail_state.dart';

class FormDetailCubit extends Cubit<FormDetailState> {
  final GetFormByIdUsecase getFormByIdUsecase;

  FormDetailCubit({required this.getFormByIdUsecase})
      : super(const FormDetailState());

  /// Fetch detail form by ID
  Future<void> getFormById(String id) async {
    emit(state.copyWith(status: FormDetailStatus.loading, errorMessage: null));

    final result = await getFormByIdUsecase(id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FormDetailStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (form) => emit(
        state.copyWith(
          status: FormDetailStatus.loaded,
          form: form,
        ),
      ),
    );
  }

  Future<void> replace(FormEntity form) async {
    emit(state.copyWith(
      errorMessage: null,
      status: FormDetailStatus.loaded,
      form: form,
    ));
  }
}
