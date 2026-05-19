import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/services/logger/app_logger.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/company/domain/usecases/internal_get_company_usecase.dart';
import 'internal_company_get_state.dart';

class InternalGetCompanyCubit extends Cubit<InternalGetCompanyState> {
  final InternalGetCompanyUsecase _usecase;

  InternalGetCompanyCubit(this._usecase)
      : super(const InternalGetCompanyState());

  Future<void> loadCompany({bool forceRefresh = false}) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await _usecase(
      forceRefresh: forceRefresh,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          error: failure.message,
        ));
      },
      (data) {
        emit(state.copyWith(
          company: data,
          isLoading: false,
        ));
      },
    );
  }

  Future<void> replaceCompany(
    CompanyEntity company,
  ) async {
    appLogger.i("repacling company FAQ : ${company.isFaqActive}");
    emit(state.copyWith(
      company: company,
      isLoading: false,
    ));
  }
}
