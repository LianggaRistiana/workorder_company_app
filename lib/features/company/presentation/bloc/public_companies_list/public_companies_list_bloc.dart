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
    on<SetCompaniesFilter>(_onSetCompaniesFilter);
  }

  Future<void> _onGetPublicCompaniesRequested(
    GetPublicCompaniesRequested event,
    Emitter<PublicCompaniesListState> emit,
  ) async {
    emit(state.copyWith(
        status: PublicCompaniesListStatus.loading, errorMessage: null));

    final result = await getCompaniesUsecase(params: state.filter);

    result.fold(
      (failure) => emit(state.copyWith(
        status: PublicCompaniesListStatus.error,
        errorMessage: failure.message,
      )),
      (companies) => emit(state.copyWith(
        status: PublicCompaniesListStatus.loaded,
        companies: companies,
        errorMessage: null,
      )),
    );
  }

  Future<void> _onSetCompaniesFilter(
    SetCompaniesFilter event,
    Emitter<PublicCompaniesListState> emit,
  ) async {
    emit(state.copyWith(
      filter: event.filter,
      status: PublicCompaniesListStatus.loading,
      errorMessage: null,
    ));

    final result = await getCompaniesUsecase(params: event.filter);

    result.fold(
      (failure) => emit(state.copyWith(
        status: PublicCompaniesListStatus.error,
        errorMessage: failure.message,
      )),
      (companies) => emit(state.copyWith(
        status: PublicCompaniesListStatus.loaded,
        companies: companies,
        errorMessage: null,
      )),
    );
  }
}
