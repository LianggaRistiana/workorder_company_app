import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/company/domain/usecases/public_get_company_detail_usecase.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/public_company_detail/public_company_detail_state.dart';

class PublicCompanyDetailCubit extends Cubit<PublicCompanyDetailState> {
  final PublicGetCompanyDetailUsecase getCompanyDetailUsecase;

  PublicCompanyDetailCubit({
    required this.getCompanyDetailUsecase,
  }) : super(const PublicCompanyDetailState());

  Future<void> getCompanyDetail(String id) async {
    emit(const PublicCompanyDetailState(
      status: PublicCompaniesListStatus.loading,
    ));

    final result = await getCompanyDetailUsecase(id);

    result.fold(
      (failure) => emit(PublicCompanyDetailState(
        status: PublicCompaniesListStatus.error,
        errorMessage: failure.message,
      )),
      (company) => emit(PublicCompanyDetailState(
        status: PublicCompaniesListStatus.loaded,
        company: company,
      )),
    );
  }
}
