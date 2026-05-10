import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/dashboard/domain/usecases/get_service_request_stats_usecase.dart';
import 'package:workorder_company_app/features/dashboard/presentation/bloc/service_request_stat/service_request_stats_state.dart';

class ServiceRequestStatsCubit extends Cubit<ServiceRequestStatsState> {
  final GetServiceRequestStatsUsecase getServiceRequestStatsUsecase;

  ServiceRequestStatsCubit(this.getServiceRequestStatsUsecase)
      : super(const ServiceRequestStatsState(
          periodType: PeriodType.currentDay,
        ));

  Future<void> fetch({
    PeriodType periodType = PeriodType.currentDay,
  }) async {
    emit(state.copyWith(
      periodType: periodType,
      status: ServiceRequestStatsStatus.loading,
    ));

    final result = await getServiceRequestStatsUsecase(state.periodType);
    result.fold(
      (fail) => emit(
        state.copyWith(
          status: ServiceRequestStatsStatus.error,
          errorMessage: fail.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          status: ServiceRequestStatsStatus.loaded,
          stats: data,
        ),
      ),
    );
  }
}
