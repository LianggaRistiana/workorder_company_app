import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';
import 'package:workorder_company_app/features/workorder/domain/usecases/set_workorder_submissions_usecase.dart';
import 'package:workorder_company_app/features/workorder/presentation/bloc/workorder_bloc.dart';


class WorkorderSubmissionsFormsCubit extends Cubit<WorkorderSubmissionsState> {
  final SetWorkorderSubmissionsUsecase _setWorkorderSubmissionsUsecase;

  WorkorderSubmissionsFormsCubit(this._setWorkorderSubmissionsUsecase)
      : super(WorkorderSubmissionsState());

  Future<void> submitSubmissions(
      String id, List<SubmissionEntity> submissions) async {
    emit(state.copyWith(status: WorkorderStateStatus.loading));
    Logger().i(submissions);
    final result = await _setWorkorderSubmissionsUsecase.call(id, submissions);
    result.fold(
      (fail) => emit(state.copyWith(
          status: WorkorderStateStatus.error, errorMessage: fail.message)),
      (data) => emit(state.copyWith(status: WorkorderStateStatus.success)),
    );
  }
}
