import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features_legacy/workorder_legacy/domain/entitties/workorder__entity.dart';
import 'package:workorder_company_app/features_legacy/workorder_legacy/domain/usecases/get_workorders_usecases.dart';

part 'workorder_event.dart';
part 'workorder_state.dart';

class WorkorderBloc extends Bloc<WorkorderEvent, WorkorderState> {
  final GetWorkordersUsecases getWorkordersUsecases;

  WorkorderBloc({required this.getWorkordersUsecases})
      : super(WorkorderState()) {
    on<GetWorkordersRequested>(_onGetWorkordersEvent);
  }

  Future<void> _onGetWorkordersEvent(
      GetWorkordersRequested event, Emitter<WorkorderState> emit) async {
    emit(state.copyWith(status: WorkorderStateStatus.loading));

    final result = await getWorkordersUsecases();

    result.fold(
      (failure) => emit(state.copyWith(
          status: WorkorderStateStatus.error, errorMessage: failure.message)),
      (workorders) => emit(state.copyWith(
          status: WorkorderStateStatus.loaded, workorders: workorders)),
    );
  }
}
