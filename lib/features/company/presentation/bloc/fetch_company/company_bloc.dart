import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_with_service_entity.dart';
import 'package:workorder_company_app/features/company/domain/usecases/get_companies_usecase.dart';
import 'package:workorder_company_app/features/company/domain/usecases/get_company_with_service_company.dart';

part 'company_state.dart';
part 'company_event.dart';

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  final GetCompaniesUsecase getCompaniesUsecase;
  final GetCompanyWithServiceUsecase getCompanyWithService;

  CompanyBloc({
    required this.getCompaniesUsecase,
    required this.getCompanyWithService,
  }) : super(CompanyState()) {
    on<GetCompaniesRequested>(_onCompaniesRequested);
    on<GetCompanyWithServiceRequested>(_onCompanyWithServiceRequested);
  }

  Future<void> _onCompaniesRequested(
    GetCompaniesRequested event,
    Emitter<CompanyState> emit,
  ) async {
    emit(state.copyWith(status: CompanyStateStatus.loading));

    final result = await getCompaniesUsecase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CompanyStateStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (companies) => emit(
        state.copyWith(
          status: CompanyStateStatus.loaded,
          companies: companies,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> _onCompanyWithServiceRequested(
    GetCompanyWithServiceRequested event,
    Emitter<CompanyState> emit,
  ) async {
    emit(state.copyWith(status: CompanyStateStatus.loading));

    final result = await getCompanyWithService(event.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CompanyStateStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (company) => emit(
        state.copyWith(
          status: CompanyStateStatus.loaded,
          selectedCompany: company,
          errorMessage: null,
        ),
      ),
    );
  }
}
