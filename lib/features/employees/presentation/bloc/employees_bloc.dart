import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/employees/domain/params/employees_params.dart';
import 'package:workorder_company_app/features/employees/domain/usecases/get_employees_usecase.dart';
import 'package:equatable/equatable.dart';

part 'employees_event.dart';
part 'employees_state.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final GetEmployeesUsecase getEmployeesUsecase;

  final Stream<void> cacheChangedStream;
  late final StreamSubscription _subscription;

  EmployeesBloc(
      {required this.getEmployeesUsecase, required this.cacheChangedStream})
      : super(const EmployeesState()) {
    on<GetEmployeesRequested>(_onGetEmployeesRequested);
    on<SetEmployeeSearch>(_onSetEmployeeSearch);

    _subscription = cacheChangedStream.listen((_) {
      add(GetEmployeesRequested(forceRefresh: false));
    });
  }

  Future<void> _onGetEmployeesRequested(
    GetEmployeesRequested event,
    Emitter<EmployeesState> emit,
  ) async {
    if (state.isLoading) return;

    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
    ));

    final response = await getEmployeesUsecase(
      params: event.params,
      forceRefresh: event.forceRefresh,
    );

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

  void _onSetEmployeeSearch(
    SetEmployeeSearch event,
    Emitter<EmployeesState> emit,
  ) {
    emit(state.copyWith(
      params: state.params.copyWith(
        search: event.search,
      ),
    ));
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
