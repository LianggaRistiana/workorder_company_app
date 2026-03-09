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
    // TODO: nanti bisa tambah event lain seperti search, refresh, filter
  }

  Future<void> _onGetFormsListRequested(
      GetFormsListRequested event, Emitter<FormsListState> emit) async {
    emit(state.copyWith(status: FormsListStatus.loading, errorMessage: null));

    final result = await getFormsUsecase();

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





// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:logger/logger.dart';
// import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
// import 'package:workorder_company_app/features/forms/domain/usecases/create_form_usecase.dart';
// import 'package:workorder_company_app/features/forms/domain/usecases/get_form_byid_usecase.dart';
// import 'package:workorder_company_app/features/forms/domain/usecases/get_forms_usecase.dart';

// part 'forms_list_event.dart';
// part 'forms_list_state.dart';

// class FormsBloc extends Bloc<FormsEvent, FormsState> {
//   final GetFormsUsecase getFormsUsecase;
//   final GetFormByIdUsecase getFormByIdUsecase;
//   final CreateFormUsecase createFormUsecase;

//   FormsBloc({
//     required this.getFormsUsecase,
//     required this.getFormByIdUsecase,
//     required this.createFormUsecase,
//   }) : super(FormsInitial()) {
//     on<GetFormsRequested>(_onFormsRequested);
//     on<GetFormByIdRequested>(_onFormByIdRequested);
//     on<CreateFormRequested>(_onCreateFormRequested);
//   }

//   Future<void> _onFormsRequested(
//     GetFormsRequested event,
//     Emitter<FormsState> emit,
//   ) async {
//     emit(FormsLoading());

//     final result = await getFormsUsecase();

//     result.fold(
//       (failure) => emit(FormsError(failure.message)),
//       (forms) => emit(FormsLoaded(forms: forms)),
//     );
//   }

// Future<void> _onCreateFormRequested(
//   CreateFormRequested event,
//   Emitter<FormsState> emit,
// ) async {
//   if (state is FormsLoaded) {
//     final current = state as FormsLoaded;
//     emit(current.copyWith(isSubLoading: true, errorMessage: null));

//     final result = await createFormUsecase(event.form);
//     result.fold(
//       (failure) => emit(
//         current.copyWith(
//           isSubLoading: false,
//           errorMessage: failure.message,
//         ),
//       ),
//       (_) => emit(
//         current.copyWith(
//           isSubLoading: false,
//         ),
//       ),
//     );
//   } else {
//     emit(FormsLoading());

//     final result = await createFormUsecase(event.form);
//     result.fold(
//       (failure) => emit(FormsError(failure.message)),
//       (_) => emit(const FormsLoaded(forms: [])),
//     );
//   }
// }


//   Future<void> _onFormByIdRequested(
//     GetFormByIdRequested event,
//     Emitter<FormsState> emit,
//   ) async {
//     if (state is FormsLoaded) {
//       final current = state as FormsLoaded;
//       emit(current.copyWith(isSubLoading: true, errorMessage: null));
//       Logger().i("Fetch in bloc FormsLoaded");

//       final result = await getFormByIdUsecase(event.id);
//       result.fold(
//         (failure) => emit(
//           current.copyWith(
//             isSubLoading: false,
//             errorMessage: failure.message,
//           ),
//         ),
//         (form) => emit(
//           current.copyWith(
//             isSubLoading: false,
//             selectedForm: form,
//           ),
//         ),
//       );
//     } else {
//       // fallback kalau user langsung fetch by id tanpa list
//       emit(FormsLoading());

//       final result = await getFormByIdUsecase(event.id);
//       result.fold((failure) => emit(FormsError(failure.message)), (form) {
//         Logger().i(form.title);
//         emit(FormsLoaded(forms: const [], selectedForm: form));
//       });
//     }
//   }
// }
