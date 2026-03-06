import 'package:workorder_company_app/core/authorization/model/policy_result.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';

enum CompanyRules {
  companyMustBeActive,
  companyDescMustBeNotNull,
  companyAddressShouldBeNotNull,
}

class CompanyManagementPolicy {
  List<PolicyResult<CompanyRules>> validate(CompanyEntity company) {
    return [
      _companyMustBeActive(company),
      _companyDescMustBeNotNull(company),
      _companyAddressShouldBeNotNull(company),
    ].where((result) => !result.isValid).toList();
  }

  PolicyResult<CompanyRules> _companyMustBeActive(CompanyEntity company) {
    if (!company.isActive) {
      return const PolicyResult.warning(CompanyRules.companyMustBeActive);
    }

    return const PolicyResult.valid();
  }

  PolicyResult<CompanyRules> _companyDescMustBeNotNull(CompanyEntity company) {
    if (company.description.isEmpty) {
      return const PolicyResult.warning(
        CompanyRules.companyDescMustBeNotNull,
      );
    }

    return const PolicyResult.valid();
  }

  PolicyResult<CompanyRules> _companyAddressShouldBeNotNull(
      CompanyEntity company) {
    if (company.address.isEmpty) {
      return const PolicyResult.warning(
        CompanyRules.companyAddressShouldBeNotNull,
      );
    }

    return const PolicyResult.valid();
  }
}