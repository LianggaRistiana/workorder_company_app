import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/services/logger/app_logger.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/employees/domain/meta/employee_detail_meta.dart';
import 'package:workorder_company_app/features/employees/domain/usecases/get_employee_detail_meta_usecase.dart';
import 'package:workorder_company_app/features/employees/domain/usecases/kick_employee_usecase.dart';
import 'package:workorder_company_app/features/employees/presentation/bloc/employee_detail_action_state.dart';

class EmployeeDetailActionCubit extends Cubit<EmployeeDetailActionState> {
  final GetEmployeeDetailMetaUsecase getEmployeeDetailMetaUsecase;
  final KickEmployeeUsecase kickEmployeeUsecase;

  EmployeeDetailActionCubit({
    required this.getEmployeeDetailMetaUsecase,
    required this.kickEmployeeUsecase,
  }) : super(const EmployeeDetailActionState(
          status: EmployeeDetailActionStatus.initial,
        ));

  Future<void> getEmployeeMeta(String? id) async {
    if (id == null) {
      return;
    }
    emit(state.copyWith(status: EmployeeDetailActionStatus.loading));

    final result = await getEmployeeDetailMetaUsecase(id);

    result.fold(
      (failure) => emit(state.copyWith(
        status: EmployeeDetailActionStatus.error,
        errorMessage: failure.message,
      )),
      (success) {
        appLogger.i(success.getMeta<EmployeeDetailMeta>()?.canKick.toString());
        emit(state.copyWith(
          status: EmployeeDetailActionStatus.loaded,
          meta: success.getMeta<EmployeeDetailMeta>(),
        ));
      },
    );
  }

  Future<void> kickEmployee(UserEntity user) async {
    emit(state.copyWith(status: EmployeeDetailActionStatus.kickLoading));

    final result = await kickEmployeeUsecase(user);

    result.fold(
      (failure) => emit(state.copyWith(
        status: EmployeeDetailActionStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        status: EmployeeDetailActionStatus.kicked,
      )),
    );
  }
}
