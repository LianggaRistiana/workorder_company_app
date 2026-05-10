import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/dashboard/domain/usecases/get_work_order_stats_usecase.dart';
import 'package:workorder_company_app/features/dashboard/presentation/bloc/work_order_stat/work_order_stats_state.dart';

class WorkOrderStatsCubit extends Cubit<WorkOrderStatsState> {
  final GetWorkOrderStatsUsecase _getWorkOrderStatsUsecase;

  WorkOrderStatsCubit(this._getWorkOrderStatsUsecase)
      : super(const WorkOrderStatsState());

  Future<void> fetch({PeriodType periodType = PeriodType.currentDay}) async {
    emit(state.copyWith(
        periodType: periodType, status: WorkOrderStatsStatus.loading));

    final result = await _getWorkOrderStatsUsecase(periodType);

    result.fold(
      (failure) => emit(state.copyWith(
        status: WorkOrderStatsStatus.error,
        errorMessage: failure.message,
      )),
      (stats) => emit(state.copyWith(
        status: WorkOrderStatsStatus.success,
        stats: stats,
      )),
    );
  }
}
