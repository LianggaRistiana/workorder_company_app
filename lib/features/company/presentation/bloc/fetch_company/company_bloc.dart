import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/company/domain/usecases/public_get_companies_usecase.dart';
import 'package:workorder_company_app/features/company/domain/usecases/public_get_company_detail_usecase.dart';
import 'package:workorder_company_app/features/company/domain/usecases/public_get_company_services.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';

part 'company_state.dart';
part 'company_event.dart';


// TODO : fix name of this bloc
class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  final PublicGetCompaniesUsecase getCompaniesUsecase;
  final PublicGetCompanyDetailUsecase getCompanyDetailUsecase;
  final PublicGetCompanyServicesUsecase getCompanyServicesUsecase;

  CompanyBloc({
    required this.getCompaniesUsecase,
    required this.getCompanyDetailUsecase,
    required this.getCompanyServicesUsecase,
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

  // TODO: Move This Logic to Usecase
  Future<void> _onCompanyWithServiceRequested(
    GetCompanyWithServiceRequested event,
    Emitter<CompanyState> emit,
  ) async {
    emit(state.copyWith(status: CompanyStateStatus.loading));

    // Jalankan dua usecase
  final companyResult = await getCompanyDetailUsecase(event.id);
  final servicesResult = await getCompanyServicesUsecase(event.id);

  // Gabungkan dua Either secara sejajar
  final result = _combineEither(companyResult, servicesResult);

  result.fold(
    (failure) => emit(state.copyWith(
      status: CompanyStateStatus.error,
      errorMessage: failure.message,
    )),
    (data) {
      final (company, services) = data;
      emit(state.copyWith(
        status: CompanyStateStatus.loaded,
        selectedCompany: company,
        selectedCompanyServices: services,
      ));
    },
  );  
  }
}


Either<Failure, (L, R)> _combineEither<L, R>(
  Either<Failure, L> leftEither,
  Either<Failure, R> rightEither,
) {
  if (leftEither.isLeft()) return leftEither as Either<Failure, (L, R)>;
  if (rightEither.isLeft()) return rightEither as Either<Failure, (L, R)>;

  final leftValue = (leftEither as Right<Failure, L>).value;
  final rightValue = (rightEither as Right<Failure, R>).value;

  return Right((leftValue, rightValue));
}