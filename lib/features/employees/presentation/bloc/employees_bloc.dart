import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/employees/domain/usecases/get_employees_usecase.dart';
import 'package:equatable/equatable.dart';

part 'employees_event.dart';
part 'employees_state.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final GetEmployeesUsecase getEmployeesUsecase;

  EmployeesBloc({required this.getEmployeesUsecase})
      : super(const EmployeesState()) {
    on<GetEmployeesRequested>(_onGetEmployeesRequested);
  }

  Future<void> _onGetEmployeesRequested(
    GetEmployeesRequested event,
    Emitter<EmployeesState> emit,
  ) async {

    // 🔥 Loading tanpa menghapus data lama
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final response = await getEmployeesUsecase();

    response.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ));
      },
      (data) {
        emit(state.copyWith(
          employees: data,
          isLoading: false,
          errorMessage: null,
        ));
      },
    );
  }
}