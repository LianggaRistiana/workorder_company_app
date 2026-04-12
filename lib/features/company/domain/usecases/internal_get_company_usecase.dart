import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/company/domain/repositories/internal_company_repository.dart';

class InternalGetCompanyUsecase {
  final InternalCompanyRepository _repository;

  InternalGetCompanyUsecase(this._repository);

  FutureEither<CompanyEntity> call({
    bool forceRefresh = false,
  }) async {
    return await _repository.getCompanyInformation(
      forceRefresh: forceRefresh,
    );
  }
}
