import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/usecases/get_forms_usecase.dart';

part 'forms_list_event.dart';
part 'forms_list_state.dart';

class FormsListBloc extends Bloc<FormsListEvent, FormsListState> {
  final GetFormsUsecase getFormsUsecase;

  FormsListBloc({required this.getFormsUsecase})
      : super(const FormsListState()) {
    on<GetFormsListRequested>(_onGetFormsListRequested);
  }

  Future<void> _onGetFormsListRequested(
      GetFormsListRequested event, Emitter<FormsListState> emit) async {
    emit(state.copyWith(status: FormsListStatus.loading, errorMessage: null));

    final result = await getFormsUsecase(
      forceRefresh: event.forceRefresh,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FormsListStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (forms) => emit(
        state.copyWith(
          status: FormsListStatus.loaded,
          forms: forms,
        ),
      ),
    );
  }
}