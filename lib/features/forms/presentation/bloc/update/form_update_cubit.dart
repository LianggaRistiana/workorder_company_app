import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/forms/domain/draft/form_draft.dart';
import 'package:workorder_company_app/features/forms/domain/usecases/update_form_usecase.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/update/form_update_state.dart';

class FormUpdateCubit extends Cubit<FormUpdateState> {
  final UpdateFormUsecase updateFormUsecase;

  FormUpdateCubit({required this.updateFormUsecase})
      : super(const FormUpdateState());

  Future<void> updateForm(FormDraft draft) async {
    emit(state.copyWith(status: FormUpdateStatus.loading));

    final result = await updateFormUsecase(draft);

    result.fold(
      (failure) => emit(state.copyWith(
        status: FormUpdateStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: FormUpdateStatus.success)),
    );
  }
}
