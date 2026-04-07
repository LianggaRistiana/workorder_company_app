import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features_legacy/workorder_legacy/domain/usecases/get_detail_workorder_usecase.dart';
import 'package:workorder_company_app/features_legacy/workorder_legacy/presentation/bloc/workorder_bloc.dart';

class WorkorderDetailCubit extends Cubit<WorkorderDetailState> {
  final GetDetailWorkorderUsecase _getDetailWorkorderUsecase;

  WorkorderDetailCubit(this._getDetailWorkorderUsecase)
      : super(const WorkorderDetailState());

  Future<void> getWorkorderDetail(String id) async {
    emit(state.copyWith(status: WorkorderStateStatus.loading));

    final data = await _getDetailWorkorderUsecase(id);
    data.fold(
        (failure) => emit(state.copyWith(
              status: WorkorderStateStatus.error,
              errorMessage: failure.message,
            )),
        (workorder) => emit(
              state.copyWith(
                status: WorkorderStateStatus.loaded,
                workorder: workorder,
              ),
            ));
  }
}
