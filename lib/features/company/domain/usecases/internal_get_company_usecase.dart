import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/result/meta/warnings_meta.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/result/result.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/company/domain/policies/company_management_policy.dart';
import 'package:workorder_company_app/features/company/domain/repositories/internal_company_repository.dart';

class InternalGetCompanyUsecase {
  final InternalCompanyRepository _repository;
  final CompanyManagementPolicy _policy;

  InternalGetCompanyUsecase(this._repository, this._policy);

  Future<Either<Failure, Result<CompanyEntity>>> call() async {
    final response = await _repository.getCompanyInformation();

    return response.map((company) {
      final evaluations = _policy.validate(company);

      final warnings =
          evaluations.where((e) => e.isWarning).map((e) => e.issue!).toList();

      final meta = <ResultMeta>[];

      if (warnings.isNotEmpty) {
        meta.add(WarningMeta<CompanyRules>(warnings));
      }

      return Result(
        data: company,
        meta: meta,
      );
    });
  }
}
