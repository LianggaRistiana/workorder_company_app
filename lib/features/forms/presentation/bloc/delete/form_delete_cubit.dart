import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/usecases/delete_form_usecase.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/delete/form_delete_state.dart';

class FormDeleteCubit extends Cubit<FormDeleteState> {
  final DeleteFormUsecase deleteFormUsecase;

  FormDeleteCubit({required this.deleteFormUsecase})
      : super(const FormDeleteState());

  Future<void> deleteForm(FormEntity form) async {
    emit(const FormDeleteState(status: FormDeleteStatus.loading));

    final result = await deleteFormUsecase(form);

    result.fold(
      (failure) => emit(
        FormDeleteState(
          status: FormDeleteStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        const FormDeleteState(status: FormDeleteStatus.deleted),
      ),
    );
  }
}
