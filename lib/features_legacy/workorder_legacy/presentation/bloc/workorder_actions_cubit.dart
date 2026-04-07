import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features_legacy/workorder_legacy/domain/usecases/set_workorder_to_ready_usecase.dart';
import 'package:workorder_company_app/features_legacy/workorder_legacy/domain/usecases/set_workorder_to_start_usecase.dart';
import 'package:workorder_company_app/features_legacy/workorder_legacy/presentation/bloc/workorder_bloc.dart';

class WorkorderActionsCubit extends Cubit<WorkorderActionsState> {
  final SetWorkorderToReadyUsecase _setWorkorderToReadyUsecase;
  final SetWorkorderToStartUsecase _setWorkorderToStartUsecase;

  WorkorderActionsCubit(
      this._setWorkorderToReadyUsecase, this._setWorkorderToStartUsecase)
      : super(const WorkorderActionsState());

  Future<void> setToReady(String id) async {
    emit(state.copyWith(status: WorkorderStateStatus.loading));
    final result = await _setWorkorderToReadyUsecase.call(id);
    result.fold(
      (fail) => emit(state.copyWith(
          status: WorkorderStateStatus.error, errorMessage: fail.message)),
      (_) => emit(state.copyWith(status: WorkorderStateStatus.success)),
    );
  }

  Future<void> setToStart(String id) async {
    emit(state.copyWith(status: WorkorderStateStatus.loading));
    final result = await _setWorkorderToStartUsecase.call(id);
    result.fold(
      (fail) => emit(state.copyWith(
          status: WorkorderStateStatus.error, errorMessage: fail.message)),
      (_) => emit(state.copyWith(status: WorkorderStateStatus.success)),
    );
  }

  Future<void> setToComplete(String id) {
    throw UnimplementedError();
  }

  Future<void> setToCancel(String id) {
    throw UnimplementedError();
  }
}
