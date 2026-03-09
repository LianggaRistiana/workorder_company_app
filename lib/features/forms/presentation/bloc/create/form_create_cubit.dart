import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/usecases/create_form_usecase.dart';
import 'form_create_state.dart';

class FormCreateCubit extends Cubit<FormCreateState> {
  final CreateFormUsecase createFormUsecase;

  FormCreateCubit({required this.createFormUsecase})
      : super(const FormCreateState());

  /// Membuat form baru
  Future<void> createForm(FormEntity form) async {
    emit(state.copyWith(status: FormCreateStatus.loading, errorMessage: null));

    final result = await createFormUsecase(form);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FormCreateStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (createdForm) => emit(
        state.copyWith(
          status: FormCreateStatus.success,
          // createdForm: createdForm,
        ),
      ),
    );
  }

  /// Reset state ke initial, misalnya setelah sukses atau batal
  void reset() {
    emit(const FormCreateState());
  }
}