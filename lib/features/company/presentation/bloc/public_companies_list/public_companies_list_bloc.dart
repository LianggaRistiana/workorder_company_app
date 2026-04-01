import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/company/domain/usecases/public_get_companies_usecase.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/public_companies_list/public_companies_list_event.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/public_companies_list/public_companies_list_state.dart';

class PublicCompaniesListBloc
    extends Bloc<PublicCompaniesListEvent, PublicCompaniesListState> {
  final PublicGetCompaniesUsecase getCompaniesUsecase;

  PublicCompaniesListBloc({
    required this.getCompaniesUsecase,
  }) : super(const PublicCompaniesListState()) {
    on<GetPublicCompaniesRequested>(_onGetPublicCompaniesRequested);
  }

  Future<void> _onGetPublicCompaniesRequested(
    GetPublicCompaniesRequested event,
    Emitter<PublicCompaniesListState> emit,
  ) async {
    emit(const PublicCompaniesListState(
        status: PublicCompaniesListStatus.loading, errorMessage: null));

    final result = await getCompaniesUsecase();

    result.fold(
      (failure) => emit(PublicCompaniesListState(
        status: PublicCompaniesListStatus.error,
        errorMessage: failure.message,
      )),
      (companies) => emit(PublicCompaniesListState(
        status: PublicCompaniesListStatus.loaded,
        companies: companies,
      )),
    );
  }
}
