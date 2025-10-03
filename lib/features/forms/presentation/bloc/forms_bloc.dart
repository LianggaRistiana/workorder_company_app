import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/usecases/get_forms_usecase.dart';

part 'forms_event.dart';
part 'forms_state.dart';

class FormsBloc extends Bloc<FormsEvent, FormsState> {
  final GetFormsUsecase getFormsUsecase;

  FormsBloc({required this.getFormsUsecase}) : super(FormsIntial()) {
    on<GetFormsRequested>(_onFormsRequested);
  }

  Future<void> _onFormsRequested(
      FormsEvent event, Emitter<FormsState> emit) async {
    emit(FormsLoading());

    final response = await getFormsUsecase();
    response.fold((failure) => emit(FormsError(failure.message)),
        (data) => emit(FormsLoaded(data)));
  }
}
