import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/dashboard/domain/usecases/get_company_stats_usecase.dart';
import 'package:workorder_company_app/features/dashboard/presentation/bloc/company_stat/company_stat_state.dart';

class CompanyStatCubit extends Cubit<CompanyStatState> {
  final GetCompanyStatsUsecase _getCompanyStatsUsecase;

  CompanyStatCubit(this._getCompanyStatsUsecase)
      : super(const CompanyStatState());

  Future<void> getCompanyStats() async {
    emit(state.copyWith(status: CompanyStatStatus.loading));

    final result = await _getCompanyStatsUsecase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: CompanyStatStatus.error,
        errorMessage: failure.message,
      )),
      (stats) => emit(state.copyWith(
        status: CompanyStatStatus.loaded,
        stats: stats,
      )),
    );
  }
}
