import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/template_config/domain/usecases/get_company_types_usecase.dart';
import 'package:workorder_company_app/features/template_config/presentation/bloc/company_type_list/company_type_list_state.dart';

class CompanyTypeListCubit extends Cubit<CompanyTypeListState> {
  final GetCompanyTypesUsecase getCompanyTypesUsecase;

  CompanyTypeListCubit({
    required this.getCompanyTypesUsecase,
  }) : super(CompanyTypeListState.initial());

  Future<void> fetchCompanyTypes() async {
    emit(state.copyWith(status: CompanyTypeListStatus.loading));
    final result = await getCompanyTypesUsecase();
    result.fold(
      (failure) => emit(state.copyWith(
        status: CompanyTypeListStatus.error,
        errorMessage: failure.message,
      )),
      (types) => emit(state.copyWith(
        status: CompanyTypeListStatus.success,
        companyTypes: types,
      )),
    );
  }
}
