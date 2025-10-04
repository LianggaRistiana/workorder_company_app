import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/usecases/get_form_byid_usecase.dart';
import 'package:workorder_company_app/features/forms/domain/usecases/get_forms_usecase.dart';

part 'forms_event.dart';
part 'forms_state.dart';

class FormsBloc extends Bloc<FormsEvent, FormsState> {
  final GetFormsUsecase getFormsUsecase;
  final GetFormByIdUsecase getFormByIdUsecase;

  FormsBloc({
    required this.getFormsUsecase,
    required this.getFormByIdUsecase,
  }) : super(FormsInitial()) {
    on<GetFormsRequested>(_onFormsRequested);
    on<GetFormByIdRequested>(_onFormByIdRequested);
  }

  Future<void> _onFormsRequested(
    GetFormsRequested event,
    Emitter<FormsState> emit,
  ) async {
    emit(FormsLoading());

    final result = await getFormsUsecase();

    result.fold(
      (failure) => emit(FormsError(failure.message)),
      (forms) => emit(FormsLoaded(forms: forms)),
    );
  }

  Future<void> _onFormByIdRequested(
    GetFormByIdRequested event,
    Emitter<FormsState> emit,
  ) async {
    // kalau sebelumnya sudah FormsLoaded, kita pertahankan datanya
    Logger().i("Fetch in bloc");
    if (state is FormsLoaded) {
      final current = state as FormsLoaded;
      emit(current.copyWith(isSubLoading: true, errorMessage: null));
      Logger().i("Fetch in bloc FormsLoaded");

      final result = await getFormByIdUsecase(event.id);
      result.fold(
        (failure) => emit(
          current.copyWith(
            isSubLoading: false,
            errorMessage: failure.message,
          ),
        ),
        (form) => emit(
          current.copyWith(
            isSubLoading: false,
            selectedForm: form,
          ),
        ),
      );
    } else {
      // fallback kalau user langsung fetch by id tanpa list
      emit(FormsLoading());

      final result = await getFormByIdUsecase(event.id);
      result.fold((failure) => emit(FormsError(failure.message)), (form) {
        Logger().i(form.title);
        emit(FormsLoaded(forms: const [], selectedForm: form));
      });
    }
  }
}
