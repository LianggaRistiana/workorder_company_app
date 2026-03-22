import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/result/meta/warnings_meta.dart';
import 'package:workorder_company_app/features/company/domain/policies/company_management_policy.dart';
import 'package:workorder_company_app/features/company/domain/usecases/internal_get_company_usecase.dart';
import 'package:workorder_company_app/features/company/presentation/mappers/company_rule_message_mapper.dart';
import 'internal_company_get_state.dart';


// TODO : rename this cubit to explicit name ex: InternalCompanyGetCubit
class InternalCompanyCubit extends Cubit<InternalCompanyState> {
  final InternalGetCompanyUsecase _usecase;

  InternalCompanyCubit(this._usecase) : super(const InternalCompanyState());

  Future<void> loadCompany() async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await _usecase();

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          error: failure.message,
        ));
      },
      (response) {
        final warningMeta =
            response.meta.whereType<WarningMeta<CompanyRules>>().firstOrNull;

        final warningMessages =
            warningMeta?.warnings.map((rule) => rule.message).toList() ?? [];

        emit(state.copyWith(
          company: response.data,
          warnings: warningMessages,
          isLoading: false,
        ));
      },
    );
  }
}
